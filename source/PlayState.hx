package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import haxe.rtti.CType.Platforms;

class PlayState extends FlxState
{
	// Create the sprite
	var sprite = new FlxSprite(10, -100);
	var movSpd = 300;

	// Init the group of walls
	var grpWalls:FlxTypedGroup<FlxSprite>;

	/**
		This function takes in the parameters:
		x positon
		y position
		width (default 560)
		height (defualt 8)
		and returns a "platform" FlxSprite.
	**/
	public function platform(x, y, width = 560, height = 8):FlxSprite
	{
		return new FlxSprite(x, y).makeGraphic(width, height, FlxColor.BLACK);
	}

	/**
		This function switches the state to GameOverState
	**/
	public function gameOver()
	{
		FlxG.switchState(new GameOverState());
	}

	override public function create()
	{
		super.create();
		bgColor = FlxColor.WHITE;
		// Load the spritesheet
		var spritesheet = FlxAtlasFrames.fromTexturePackerJson("assets/images/spritesheet.png", "assets/images/spritesheet.json");
		sprite.frames = spritesheet;
		// Array containing the frame names
		var names = [];
		for (i in 0...5)
		{
			names.push("walk_00" + i + ".png");
		}
		// Create the walk animation using the frame names and a frame rate of 10
		sprite.animation.addByNames("walk", names, 10);
		// Scale the sprites down to a reasonable size
		sprite.scale.set(0.1, 0.1);
		// Update the hitbox of the sprite
		sprite.updateHitbox();
		sprite.acceleration.y = 1300;
		add(sprite);

		grpWalls = new FlxTypedGroup<FlxSprite>();

		// Create the outer walls
		grpWalls.add(new FlxSprite(0, -8).makeGraphic(FlxG.width, 8)); // top
		grpWalls.add(new FlxSprite(FlxG.width, 0).makeGraphic(8, FlxG.height)); // right
		grpWalls.add(new FlxSprite(-8, 0).makeGraphic(8, FlxG.height)); // left
		// No bottom wall to allow for sprite to fall through to next level

		// Create the platforms
		var platform1 = platform(0, 300);
		var platform2 = platform(500, 500);
		var platform3 = platform(0, 700);
		var platform4 = platform(FlxG.width - 560, 700);
		grpWalls.add(platform1);
		grpWalls.add(platform2);
		grpWalls.add(platform3);
		grpWalls.add(platform4);

		// Make all the walls immovable
		for (wall in grpWalls)
		{
			wall.immovable = true;
		}

		add(grpWalls);
	}

	override public function update(elapsed:Float)
	{
		/**
			I want the walking animation to be cancelled if the player presses both directional inputs
			at the same time. Some games don't follow this design, but this I like it.
		**/
		if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT)
		{
			sprite.flipX = false;
			sprite.animation.play("walk");
			sprite.velocity.x = movSpd;
		}
		else if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
		{
			sprite.flipX = true;
			sprite.animation.play("walk");
			sprite.velocity.x = movSpd * -1;
		}
		else
		{
			// Reset the sprite to default animation when done walking
			// Currently looks odd, would be nice to have a default standing animation
			sprite.animation.reset();
			sprite.velocity.x = 0;
		}

		// Check for collision between sprite and platforms
		FlxG.collide(grpWalls, sprite);

		if (!sprite.isOnScreen())
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, gameOver);
		}
		super.update(elapsed);
	}
}

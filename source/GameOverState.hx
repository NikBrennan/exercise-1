package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import haxe.rtti.CType.Platforms;

class GameOverState extends FlxState
{
	override public function create()
	{
		super.create();
		bgColor = FlxColor.BLACK;
		var text = new FlxText();
		text.text = "Game Over";
		text.size = 32;
		text.screenCenter();
		text.color = FlxColor.RED;
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

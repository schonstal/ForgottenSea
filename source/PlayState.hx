package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

class PlayState extends FlxState
{
  override public function create():Void {
    super.create();

    var player = new Player();
    add(player);
  }

  override public function update():Void {
    super.update();
  }
}

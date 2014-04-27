package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

class MenuState extends FlxState
{
  override public function create():Void {
    add(new FlxText(FlxG.width/2,FlxG.height/2,100,"YO YO YO"));
    super.create();
  }
	
  override public function destroy():Void {
    super.destroy();
	}

  override public function update():Void {
    if(FlxG.mouse.justPressed) {
      FlxG.switchState(new PlayState());
    }
    super.update();
  }
}

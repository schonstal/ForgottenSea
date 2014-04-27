package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxVector;

class Player extends FlxSprite
{
  inline static var SPEED = 100;

  public function new() {
    super();
    loadGraphic("assets/images/player.png", true, 16, 16);
    animation.add("walk", [6,7,8], 5, true);
    animation.play("walk");
  }

  public override function update():Void {
    processMovement();
    super.update();
  }

  private function processMovement():Void {
    var direction:FlxVector = new FlxVector(0,0);

    if(FlxG.keys.pressed.W) {
      direction.y = -1;
    }
    if(FlxG.keys.pressed.S) {
      direction.y = 1;
    }
    if(FlxG.keys.pressed.A) {
      direction.x = -1;
    }
    if(FlxG.keys.pressed.D) {
      direction.x = 1;
    }

    if(direction.length > 0) {
      velocity.x = direction.normalize().x * SPEED;
      velocity.y = direction.normalize().y * SPEED;
    } else {
      velocity.x = velocity.y = 0;
    }
  }
}

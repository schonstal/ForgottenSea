package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxVector;
import flash.display.BlendMode;

class Player extends FlxSprite
{
  inline static var SPEED = 400;

  public function new() {
    super();
    loadGraphic("assets/images/player.png", true, 16, 16);
    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
    animation.add("walk", [6,7,8], 5, true);
    animation.add("stand", [7], 5);
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
      facing = FlxObject.LEFT;
      direction.x = -1;
    }
    if(FlxG.keys.pressed.D) {
      facing = FlxObject.RIGHT;
      direction.x = 1;
    }

    if(direction.length > 0) {
      velocity.x = direction.normalize().x * SPEED;
      velocity.y = direction.normalize().y * SPEED;
      animation.play("walk");
    } else {
      velocity.x = velocity.y = 0;
      animation.play("stand");
    }
  }
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxVector;
import flash.display.BlendMode;

class Player extends FlxSprite
{
  inline static var SPEED = 100;

  public function new() {
    super();
    loadGraphic("assets/images/player.png", true, 32, 32);
    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
    animation.add("walk", [0], 5, true);
    animation.add("idle", [0,0,1,2,3,3], 10);
    width = 22;
    height = 12;
    offset.x = 4;
    offset.y = 20;
  }

  public override function update():Void {
    processMovement();

    facing = FlxG.mouse.x < x + width/2 ? FlxObject.LEFT : FlxObject.RIGHT;

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
      animation.play("walk");
    } else {
      velocity.x = velocity.y = 0;
      animation.play("idle");
    }
  }
}

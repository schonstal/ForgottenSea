package;

import flixel.group.FlxSpriteGroup;

import flixel.FlxSprite;
import flixel.FlxG;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;
import flixel.util.FlxVector;
import flixel.util.FlxTimer;

class Torch extends FlxSprite
{
  public var onCollisionCallback:Void->Void;

  private var lit:Bool = false;
  private var light:Bool = false;

  public function new(X:Float, Y:Float) {
    super(X * 32 + 2, Y * 32 + 10);
    loadGraphic("assets/images/sconce.png", false, 28, 48);
    height = 20;
    offset.y = 28;
    immovable = true;
    animation.add("off", [0]);
    animation.add("light", [1,2,1,2,3,4,3,4,5,6,6,7], 15, false);
    animation.add("lit", [8,8,9,10,10,11], 15);
    animation.callback = onAnimate;
  }

  public function onCollide() {
    if(!light && !lit) {
      if(onCollisionCallback != null) onCollisionCallback();
      animation.play("light");
    }
    light = true;
  }

  public override function update():Void {
    if(light) animation.play("light");
    if(lit) animation.play("lit");
    super.update();
  }

  private function onAnimate(name:String, frame:Int, frameIndex:Int):Void {
    if (name == "light" && frame == 11) {
      lit = true;
      light = false;
    }
  }
}

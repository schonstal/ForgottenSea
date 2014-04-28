package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;

import flixel.util.FlxRandom;
import flixel.util.FlxPoint;

import flixel.group.FlxSpriteGroup;

import flash.display.BlendMode;

class Reticle extends FlxSpriteGroup
{
  var bigSprite:FlxSprite;
  var littleSprite:FlxSprite;

  public function new() {
    super();

    bigSprite = new FlxSprite();
    bigSprite.loadGraphic("assets/images/retical.png", false, 16, 16);
    bigSprite.animation.add("default", [0]);
    bigSprite.animation.play("default");
    bigSprite.angularVelocity = 200;
    add(bigSprite);

    littleSprite = new FlxSprite();
    littleSprite.loadGraphic("assets/images/retical.png", false, 16, 16);
    littleSprite.animation.add("default", [1]);
    littleSprite.animation.play("default");
    littleSprite.angularVelocity = -200;
    add(littleSprite);

    blend = BlendMode.ADD;
    alpha = 0.5;
  }

  public override function update():Void {
    super.update();

    //TODO: Laggy for some reason, find out why
    x = FlxG.mouse.x - bigSprite.width/2 + 1;
    y = FlxG.mouse.y - bigSprite.height/2 + 1;
  }
}

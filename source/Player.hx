package;

import flixel.addons.effects.FlxTrail;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;

import flixel.util.FlxVector;

import flash.display.BlendMode;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.tweens.misc.VarTween;

class Player extends FlxSprite
{
  inline static var SPEED = 100;
  inline static var DASH_DISTANCE = 60;
  inline static var DASH_DURATION = 0.6;
  inline static var IFRAME_DURATION = 0.3;

  public var invulnerable:Bool = true;

  var dashTween:VarTween;
  var dashScaleTween:VarTween;

  var dashing:Bool = false;

  public function new() {
    super();
    loadGraphic("assets/images/player.png", true, 32, 32);
    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
    animation.add("walk", [4,5,6,7,8,9,10,11], 15, true);
    animation.add("walkBackwards", [4,11,10,9,8,7,6,5], 15, true);
    animation.add("idle", [0,0,1,2,3,3], 10);
    animation.add("dash", [0]);
    width = 22;
    height = 12;
    offset.x = 4;
    offset.y = 20;
  }

  public override function update():Void {
    facing = FlxG.mouse.x < x + width/2 ? FlxObject.LEFT : FlxObject.RIGHT;

    if(!dashing) {
      processMovement();
    } else {
      animation.play("dash");
    }

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

    if(FlxG.keys.justPressed.SPACE && (direction.x != 0 || direction.y != 0)) {
      startDash(direction.normalize());
    }

    if(direction.length > 0) {
      velocity.x = direction.normalize().x * SPEED;
      velocity.y = direction.normalize().y * SPEED;
      if((velocity.x < 0 && facing == FlxObject.RIGHT) || (velocity.x > 0 && facing == FlxObject.LEFT)) {
        animation.play("walkBackwards");
      } else {
        animation.play("walk");
      }
    } else {
      velocity.x = velocity.y = 0;
      animation.play("idle");
    }
  }

  private function startDash(direction:FlxVector):Void {
    velocity.x = velocity.y = 0;
    dashing = true;
    invulnerable = true;
    scale.x = 1.5;
    scale.y = 0.5;
    alpha = 0.6;

    dashTween = FlxTween.tween(this, {
        x: x + (direction.x * DASH_DISTANCE),
        y: y + (direction.y * DASH_DISTANCE)
      }, DASH_DURATION, { ease: FlxEase.quintOut });
    dashScaleTween = FlxTween.tween(scale, {
        x: 1,
        y: 1
      }, DASH_DURATION, { ease: FlxEase.quintOut, complete: onDashComplete });

    FlxTween.tween(this, { alpha: 1 }, IFRAME_DURATION, { ease: FlxEase.quartIn, complete: onIframeComplete });
  }

  public function cancelDash():Void {
    if(dashTween != null) dashTween.cancel();
    velocity.x = velocity.y = 0;
  }

  private function onDashComplete(callback):Void {
    dashing = false;
  }

  private function onIframeComplete(callback):Void {
    invulnerable = false;
  }
}

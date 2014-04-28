package;

import flixel.group.FlxSpriteGroup;

import flixel.FlxSprite;
import flixel.FlxG;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;
import flixel.util.FlxVector;
import flixel.util.FlxTimer;

import flixel.tile.FlxTilemap;

class ProjectileSprite extends FlxSprite {
  public var onCollisionCallback:Void->Void;

  public function new() {
    super();
    loadGraphic("assets/images/player_magic_ball.png", false, 32, 32);
    animation.add("pulse", [0,1,2,3], 15);
    animation.play("pulse");
    width = 20;
    height = 10;
    offset.y = 22;
    offset.x = 6;
  }

  public function onCollide() {
    if(onCollisionCallback != null) onCollisionCallback();
  }
}

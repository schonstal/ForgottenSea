package;

import flixel.group.FlxSpriteGroup;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

import flixel.group.FlxTypedGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;
import flixel.util.FlxVector;
import flixel.util.FlxTimer;

import flixel.tile.FlxTilemap;

class Torches extends FlxSpriteGroup
{
  public var lit = 0;

  public function new(dungeonObjects:FlxTypedGroup<FlxObject>) {
    super();

    for(l in G.torchLocations) {
      var torch = new Torch(l.x, l.y);
      torch.onCollisionCallback = onLight;
      add(torch);
      dungeonObjects.add(torch);
    }
  }

  public function onLight() {
    lit += 1;
  }
}

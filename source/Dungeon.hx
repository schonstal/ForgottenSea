package;

import flixel.group.FlxGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;

import flixel.tile.FlxTilemap;

class Dungeon extends FlxGroup
{
  var dungeonTiles:DungeonTiles;
  var groundTilemap:FlxTilemap;

  public function new() {
    super();
    dungeonTiles = new DungeonTiles(20,20);

    groundTilemap = new FlxTilemap();
    groundTilemap.loadMap(FlxStringUtil.arrayToCSV(dungeonTiles.tiles, 10),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    add(groundTilemap);
  }
}

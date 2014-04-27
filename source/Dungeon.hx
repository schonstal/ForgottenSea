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
    dungeonTiles = new DungeonTiles(60,60);

    var flattenedArray:Array<Int> = new Array<Int>(); 
    for (tileArray in dungeonTiles.tiles) {
      for (tile in tileArray) {
        flattenedArray.push(tile);
      }
    }

    groundTilemap = new FlxTilemap();
    groundTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenedArray, 60),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    add(groundTilemap);
  }
}

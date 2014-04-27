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
    dungeonTiles = new DungeonTiles(40,40);
    var flattenedArray:Array<Int> = new Array<Int>(); 
    for (tileArray in dungeonTiles.tiles) {
      for (tile in tileArray) {
        flattenedArray.push(tile);
      }
    }

    groundTilemap = new FlxTilemap();
    groundTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenedArray, 40),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    groundTilemap.x = -20 * 32;
    groundTilemap.y = -20 * 32;

    add(groundTilemap);
  }
}

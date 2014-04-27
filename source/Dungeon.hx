package;

import flixel.group.FlxGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;

import flixel.tile.FlxTilemap;

class Dungeon extends FlxGroup
{
  var dungeonTiles:DungeonTiles;
  var drapedTiles:DrapedTiles;

  var groundTilemap:FlxTilemap;
  var drapedTilemap:FlxTilemap;

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


    drapedTiles = new DrapedTiles(dungeonTiles);
    flattenedArray = new Array<Int>(); 
    for (tileArray in drapedTiles.tiles) {
      for (tile in tileArray) {
        flattenedArray.push(tile);
      }
    }

    drapedTilemap = new FlxTilemap();
    drapedTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenedArray, 40),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    drapedTilemap.x = groundTilemap.x;
    drapedTilemap.y = groundTilemap.y;
    add(drapedTilemap);

  }
}

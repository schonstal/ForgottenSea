package;

import flixel.group.FlxGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;

import flixel.tile.FlxTilemap;

class Dungeon extends FlxGroup
{
  inline static var SIZE = 40;

  var dungeonTiles:DungeonTiles;
  var drapedTiles:DrapedTiles;
  var isometricWalls:IsometricWalls;

  var groundTilemap:FlxTilemap;
  var drapedTilemap:FlxTilemap;
  var wallTilemap:FlxTilemap;

  public function new() {
    super();
    dungeonTiles = new DungeonTiles(SIZE,SIZE);

    groundTilemap = new FlxTilemap();
    groundTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(dungeonTiles.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    groundTilemap.x = -20 * 32;
    groundTilemap.y = -20 * 32;
    add(groundTilemap);

    drapedTiles = new DrapedTiles(dungeonTiles);

    drapedTilemap = new FlxTilemap();
    drapedTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(drapedTiles.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    drapedTilemap.x = groundTilemap.x;
    drapedTilemap.y = groundTilemap.y;
    add(drapedTilemap);

    isometricWalls = new IsometricWalls(dungeonTiles);
    wallTilemap = new FlxTilemap();
    wallTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(isometricWalls.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    wallTilemap.x = groundTilemap.x;
    wallTilemap.y = groundTilemap.y;
    add(wallTilemap);
  }

  private function flattenArray(array:Array<Array<Int>>):Array<Int> {
    var flattenedArray = new Array<Int>(); 
    for (tileArray in array) {
      for (tile in tileArray) {
        flattenedArray.push(tile);
      }
    }

    return flattenedArray;
  }
}

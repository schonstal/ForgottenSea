package;

import flixel.group.FlxGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;

import flixel.tile.FlxTilemap;

class Dungeon extends FlxGroup
{
  inline public static var SIZE = 40;

  //We have to add this one separately to layer it on top
  public var wallTopTilemap:FlxTilemap;
  public var wallTilemap:FlxTilemap;
  public var collisionTilemap:FlxTilemap;

  var dungeonTiles:DungeonTiles;
  var drapedTiles:DrapedTiles;
  var isometricWalls:IsometricWalls;
  var isometricTops:IsometricTops;

  var groundTilemap:FlxTilemap;
  var drapedTilemap:FlxTilemap;
  var drapedWallTilemap:FlxTilemap;

  public function new() {
    super();
    dungeonTiles = new DungeonTiles(SIZE,SIZE);

    groundTilemap = new FlxTilemap();
    groundTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(dungeonTiles.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    groundTilemap.x = -20 * 32;
    groundTilemap.y = -20 * 32;
    add(groundTilemap);

    //Invert the tiles for collision
    collisionTilemap = new FlxTilemap();
    var collisionArray:Array<Int> = flattenArray(dungeonTiles.tiles);
    for (i in 0...collisionArray.length-1) {
      if(collisionArray[i] > 0) {
        collisionArray[i] = 0;
      } else {
        collisionArray[i] = 1;
      }
    }
    collisionTilemap.loadMap(FlxStringUtil.arrayToCSV(collisionArray, SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    collisionTilemap.x = groundTilemap.x;
    collisionTilemap.y = groundTilemap.y;

    isometricWalls = new IsometricWalls(dungeonTiles);
    wallTilemap = new FlxTilemap();
    wallTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(isometricWalls.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    wallTilemap.x = groundTilemap.x;
    wallTilemap.y = groundTilemap.y;
    add(wallTilemap);

    var draperArray:Array<Array<Int>> = new Array<Array<Int>>();
    for (y in 0...dungeonTiles.tiles.length) {
      draperArray[y] = new Array<Int>();
      for (x in 0...dungeonTiles.tiles[0].length) {
        draperArray[y][x] = ((dungeonTiles.tiles[y][x] + isometricWalls.tiles[y][x]) > 0 ? 1 : 0);
      }
    }

    drapedTiles = new DrapedTiles(draperArray);

    drapedTilemap = new FlxTilemap();
    drapedTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(drapedTiles.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    drapedTilemap.x = groundTilemap.x;
    drapedTilemap.y = groundTilemap.y;
    add(drapedTilemap);

    isometricTops = new IsometricTops(isometricWalls);
    wallTopTilemap = new FlxTilemap();
    wallTopTilemap.loadMap(FlxStringUtil.arrayToCSV(flattenArray(isometricTops.tiles), SIZE),
                          "assets/images/tiles.png", 32, 32, FlxTilemap.OFF);
    wallTopTilemap.x = groundTilemap.x;
    wallTopTilemap.y = groundTilemap.y;
    
    collisionTilemap.visible = false;
    add(collisionTilemap);
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

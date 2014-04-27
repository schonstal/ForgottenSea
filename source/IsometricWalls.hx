package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

class IsometricWalls
{
  inline static var NORTH = 0x01;
  inline static var EAST  = 0x02;
  inline static var SOUTH = 0x04;
  inline static var WEST  = 0x08;

  public var tiles:Array<Array<Int>>;
  public var topTiles:Array<Array<Int>>;

  var dungeonTiles:DungeonTiles;

  /* Index on tilemap is bitwise or with presence of adjacent tiles on the cardinal directions
   * Starting with the least significant bit:
   * 0b0001 = 0x01 => A tile is present in the north
   * 0b0010 = 0x02 => A tile is present in the east
   * 0b0100 = 0x04 => A tile is present in the south
   * 0b1000 = 0x08 => A tile is present in the west
   */

  var tileMap:Array<Array<Int>> = [
    [24],             // -          (0b0000)
    [24],             // N          (0b0001)
    [12],             // E          (0b0010)
    [12],             // N, E       (0b0011)
    [25, 27, 28, 35], // S          (0b0100)
    [25, 27, 28, 35], // N, S       (0b0101)
    [15, 15, 32, 32], // S, E       (0b0110)
    [29, 15, 37, 32], // S, E, N    (0b0111)
    [14],             // W          (0b1000)
    [14],             // W, N       (0b1001)
    [13],             // W, E       (0b1010)
    [13],             // W, E, N    (0b1011)
    [17, 31, 17, 31], // W, S       (0b1100)
    [30, 38, 17, 31], // W, S, N    (0b1101)
    [36, 34, 33, 16], // W, S, E    (0b1110)
    [36, 34, 33, 16]  // N, E, S, W (0b1111)
  ];

  public function new(dungeonTiles) {
    this.dungeonTiles = dungeonTiles;
    generateTiles();
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    //Pass through tilemap and add solids
    for(y in 0...dungeonTiles.height) {
      tiles[y] = new Array<Int>();
      for(x in 0...dungeonTiles.width) {
        if(dungeonTiles.tiles[y][x] == 0) {
          tiles[y][x] = 16;
        } else {
          tiles[y][x] = 0;
        }
      }
    }

    //TODO: Cut out lakes

    //Find edges
    for(y in 0...dungeonTiles.height) {
      for(x in 0...dungeonTiles.width) {
        if(tiles[y][x] > 0) {
          layTile(x, y);
        }
      }
    }
  }

  private function layTile(x:Int, y:Int):Void {
    var quadIndex:Int = 0;
    var tileIndex = 0;

    if(y > 0 && tiles[y-1][x] > 0) tileIndex |= NORTH;
    if(x < tiles[y].length-1 && tiles[y][x+1] > 0) tileIndex |= EAST;

    //If there's a tile below, we have to pick from one of four tiles.
    if(y < tiles.length-1) {
      var row = tiles[y+1];
      if(row[x] > 0) {
        tileIndex |= SOUTH;
        if(x < row.length-1 && row[x+1] > 0) quadIndex |= 0x01;
        if(x > 0 && row[x-1] > 0) quadIndex |= 0x02;
      }
    }

    if(x > 0 && tiles[y][x-1] > 0) tileIndex |= WEST;

    tiles[y][x] = tileMap[tileIndex][quadIndex];
  }
}

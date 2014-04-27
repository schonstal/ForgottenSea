package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

class IsometricTops
{
  public var tiles:Array<Array<Int>>;

  var isometricWalls:IsometricWalls;

  //TOP LEFT = 18
  //MID = 19
  //TOP RIGHT = 20
  //CAP = 26

  var tileMap:Array<Int> = [26, 20, 18, 19];

  public function new(isometricWalls) {
    this.isometricWalls = isometricWalls;
    generateTiles();
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    for(y in 0...isometricWalls.tiles.length) {
      tiles[y] = new Array<Int>();
      for(x in 0...isometricWalls.tiles[0].length) {
        tiles[y][x] = 0;
        if(y < isometricWalls.tiles.length-1) {
          var tileIndex:Int = 0;
          var row = isometricWalls.tiles[y+1];
          if(row[x] > 0 && isometricWalls.tiles[y][x] == 0) {
            if(x > 0 && row[x-1] > 0) tileIndex |= 0x01;
            if(x < row.length-1 && row[x+1] > 0) tileIndex |= 0x02;
            tiles[y][x] = tileMap[tileIndex];
          }
        }
      }
    }
  }
}

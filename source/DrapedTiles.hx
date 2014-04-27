package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

class DrapedTiles
{
  public var tiles:Array<Array<Int>>;

  var dungeonTiles:Array<Array<Int>>;

  public function new(dungeonTiles:Array<Array<Int>>) {
    this.dungeonTiles = dungeonTiles;
    generateTiles();
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    for(y in 0...dungeonTiles.length) {
      tiles[y] = new Array<Int>();
      for(x in 0...dungeonTiles[0].length) {
        if (y > 0 && dungeonTiles[y][x] == 0 && dungeonTiles[y-1][x] > 0) {
          if (x > 0 && dungeonTiles[y-1][x-1] == 0) {
            tiles[y][x] = 21;
          } else if (x < dungeonTiles[0].length - 1 && dungeonTiles[y-1][x+1] == 0) {
            tiles[y][x] = 23;
          } else {
            tiles[y][x] = 22;
          }
        } else {
          tiles[y][x] = 0;
        }
      }
    }
  }
}

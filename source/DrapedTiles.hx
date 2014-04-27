package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

class DrapedTiles
{
  public var tiles:Array<Array<Int>>;

  var dungeonTiles:DungeonTiles;

  public function new(dungeonTiles) {
    this.dungeonTiles = dungeonTiles;
    generateTiles();
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    for(y in 0...dungeonTiles.height) {
      tiles[y] = new Array<Int>();
      for(x in 0...dungeonTiles.width) {
        if (y > 0 && dungeonTiles.tiles[y][x] == 0 && dungeonTiles.tiles[y-1][x] > 0) {
          if (x > 0 && dungeonTiles.tiles[y-1][x-1] == 0) {
            tiles[y][x] = 21;
          } else if (x < dungeonTiles.width - 1 && dungeonTiles.tiles[y-1][x+1] == 0) {
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

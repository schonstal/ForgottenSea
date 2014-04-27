package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;

class DungeonTiles
{
  inline static var DEPTH = 4; //How far to recurse down the tree
  inline static var EDGE_TOLERANCE = 0.3; //How close to the edge can we divide? percentage.
  inline static var MIN_SIZE = 0.6;

  var children:Array<DungeonTiles> = new Array<DungeonTiles>();
  var depth:Int = 0; //What step we're on
  var verticalSplit:Bool;

  var width:Int;
  var height:Int;

  var room:FlxRect;

  public var tiles(get,null):Array<Array<Int>>;

  public function new(width:Int, height:Int, depth:Int=0) {
    this.depth = depth;
    this.width = width;
    this.height = height;
    verticalSplit = FlxRandom.chanceRoll(50);

    if (depth < DEPTH) {
      generateChildren();
    } else {
      generateRoom();
      generateTiles();
    }
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    for(y in 0...height) {
      tiles[y] = new Array<Int>();
      for(x in 0...width) {
        tiles[y][x] = (x >= room.x && x <= room.x + room.width &&
                       y >= room.y && y <= room.y + room.height) ?
                       1 : 0;
      }
    }
  }

  private function generateRoom():Void {
    room = new FlxRect();
    room.width = FlxRandom.intRanged(Std.int(width * MIN_SIZE), width);
    room.height = FlxRandom.intRanged(Std.int(width * MIN_SIZE), width);
    room.x = FlxRandom.intRanged(0, width - Std.int(room.width));
    room.y = FlxRandom.intRanged(height - Std.int(room.height), 0);
  }

  private function generateChildren():Void {
    var newWidth = width;
    var newHeight = height;

    if (verticalSplit) {
      newWidth = FlxRandom.intRanged(Std.int(width * EDGE_TOLERANCE), Std.int(width * (1-EDGE_TOLERANCE)));
      children[0] = new DungeonTiles(width - newWidth, height, depth+1);
    } else {
      newHeight = FlxRandom.intRanged(Std.int(height * EDGE_TOLERANCE), Std.int(height * (1-EDGE_TOLERANCE)));
      children[0] = new DungeonTiles(width, height - newHeight, depth+1);
    }
    children[1] = new DungeonTiles(newWidth, newHeight, depth+1);
  }

  private function get_tiles():Array<Array<Int>> {
    if (tiles == null) {
      tiles = new Array<Array<Int>>();
      for (tile in children[0].tiles) {
        tiles.push(tile);
      }
      if (!verticalSplit) {
        for (tile in children[1].tiles) {
          tiles.push(tile);
        }
      } else {
        for (i in 0...height-1) {
          tiles[i].concat(children[1].tiles[i]);
        }
      }
    }
    
    return tiles;
  }
}

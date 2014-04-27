package;

import flixel.FlxObject;
import flixel.util.FlxRandom;

class DungeonTiles extends FlxObject
{
  inline static var DEPTH = 4; //How far to recurse down the tree

  var leaves:Array<Dungeon> = new Array<Dungeon>();
  var depth:Int = 0; //What step we're on

  public var tiles(get,null):Array<Int>;

  public function new(width:Int, height:Int, depth:Int=0) {
    super();
    this.depth = depth;
    this.width = width;
    this.height = height;

    if (depth < DEPTH) {
      depth++;
    }
  }

  private function get_tiles():Array<Int> {
    return [1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1];
  }
}

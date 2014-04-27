package;

import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

class DungeonTiles
{
  inline static var BRUSH_SIZE = 2;

  var position:FlxPoint;
  var direction:FlxVector;

  var width:Int;
  var height:Int;

  public var tiles:Array<Array<Int>>;

  public function new(width:Int, height:Int) {
    this.width = width;
    this.height = height;
    position = new FlxPoint(width/2, height/2);
    direction = new FlxVector(1,0);

    generateTiles();
  }

  private function generateTiles():Void {
    tiles = new Array<Array<Int>>();
    for(y in 0...height) {
      tiles[y] = new Array<Int>();
      for(x in 0...width) {
        tiles[y][x] = 0;
      }
    }

    for(i in 0...400) {
      position.x += direction.x;
      position.y += direction.y;

      
      var localSize = BRUSH_SIZE + (FlxRandom.chanceRoll(5) ? 1 : 0);
      for(x in 0...localSize) {
        for(y in 0...localSize) {
          var localY = Std.int(position.y) + y;
          var localX = Std.int(position.x) + x;

          tiles[localY][localX] = (localY + localX % 2 == 0 ? 1 : 2);
        }
      }
      changeDirection();
    }
  }

  private function changeDirection():Void {
    if (FlxRandom.chanceRoll(40) || outOfBounds()) {

      direction.x = FlxRandom.intRanged(-1,1);
      direction.y = FlxRandom.intRanged(-1,1);
    }

    if(outOfBounds())
      changeDirection();
  }

  private function outOfBounds():Bool {
    return position.x + direction.x * (BRUSH_SIZE + 1) + BRUSH_SIZE >= width ||
           position.x + direction.x * (BRUSH_SIZE + 1) < 0 ||
           position.y + direction.y * (BRUSH_SIZE + 1) + BRUSH_SIZE >= height ||
           position.y + direction.y * (BRUSH_SIZE + 1) < 0;
  }
}

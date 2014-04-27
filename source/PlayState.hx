package;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.effects.FlxGlitchSprite;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;

import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxStringUtil;

import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
  private var player:Player;
  private var cameraObject:FlxObject;
  private var water:FlxSprite;

  private var dungeon:Dungeon;

  override public function create():Void {
    super.create();

    var water = new Water();
    add(water);

    dungeon = new Dungeon();
    add(dungeon);
    
    player = new Player();
    add(player);

    cameraObject = new FlxObject();
    add(cameraObject);

    FlxG.camera.follow(cameraObject, FlxCamera.STYLE_LOCKON, new FlxPoint(-player.width/2,-player.height/2), 0);
  }

  override public function update():Void {
    cameraObject.x = (FlxG.mouse.x + player.x*3)/4;
    cameraObject.y = (FlxG.mouse.y + player.y*3)/4;
    super.update();
  }
}

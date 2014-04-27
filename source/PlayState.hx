package;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.effects.FlxGlitchSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

class PlayState extends FlxState
{
  private var player:Player;
  private var cameraObject:FlxObject;
  private var water:FlxSprite;

  override public function create():Void {
    super.create();

    var water = new Water();
    add(water);
    
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

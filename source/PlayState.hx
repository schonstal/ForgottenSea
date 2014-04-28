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

class PlayState extends FlxState
{
  private var player:Player;
  private var reticle:Reticle;
  private var cameraObject:FlxObject;
  private var water:FlxSprite;

  private var dungeon:Dungeon;

  override public function create():Void {
    super.create();
    FlxG.mouse.visible = false;
    FlxG.debugger.drawDebug = true;
    FlxG.debugger.visible = true;

    var water = new Water();
    water.x = -FlxG.width/2;
    water.y = -FlxG.height/2;
    water.alpha = 0.2;
    water.scrollFactor.x = water.scrollFactor.y = 0.2;
    add(water);

    dungeon = new Dungeon();
    add(dungeon);
    
    player = new Player();
    add(player);

    add(dungeon.wallTopTilemap);

    cameraObject = new FlxObject();
    add(cameraObject);

    reticle = new Reticle();
    add(reticle);

    add(new Projectile());

    FlxG.camera.follow(cameraObject, FlxCamera.STYLE_LOCKON, new FlxPoint(-player.width/2,-player.height/2), 0);

    FlxG.worldBounds.width = FlxG.worldBounds.height = Dungeon.SIZE * 32;
    FlxG.worldBounds.x = dungeon.wallTilemap.x;
    FlxG.worldBounds.y = dungeon.wallTilemap.y;

    //FlxG.sound.play("assets/music/seacave_music1.wav");
    //FlxG.sound.play("assets/sounds/seacave_ambience1.wav");
  }

  override public function update():Void {
    cameraObject.x = (FlxG.mouse.x + player.x*3)/4;
    cameraObject.y = (FlxG.mouse.y + player.y*3)/4;

    super.update();
    FlxG.collide(player, dungeon.collisionTilemap, function(a,b):Void { player.cancelDash(); });
  }
}

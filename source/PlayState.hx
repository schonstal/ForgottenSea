package;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.effects.FlxGlitchSprite;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
  private var player:Player;
  private var reticle:Reticle;
  private var cameraObject:FlxObject;
  private var water:FlxSprite;

  private var dungeon:Dungeon;

  private var dungeonObjects:FlxTypedGroup<FlxObject>;
  private var projectiles:FlxTypedGroup<FlxObject>;

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
    
    reticle = new Reticle();

    dungeonObjects = new FlxTypedGroup<FlxObject>();
    G.projectiles = new FlxTypedGroup<FlxObject>();

    player = new Player(dungeonObjects, reticle);
    dungeonObjects.add(player);
    add(dungeonObjects);

    add(dungeon.wallTopTilemap);

    cameraObject = new FlxObject();
    add(cameraObject);

    add(reticle);

    FlxG.camera.follow(cameraObject, FlxCamera.STYLE_LOCKON, new FlxPoint(-player.width/2,-player.height/2), 0);

    FlxG.worldBounds.width = FlxG.worldBounds.height = Dungeon.SIZE * 32;
    FlxG.worldBounds.x = dungeon.wallTilemap.x;
    FlxG.worldBounds.y = dungeon.wallTilemap.y;

    FlxG.sound.play("assets/music/seacave_music1.wav", 0.9);
    FlxG.sound.playMusic("assets/sounds/seacave_ambience1.wav", 0.25);
  }

  override public function update():Void {
    cameraObject.x = (FlxG.mouse.x + player.x*3)/4;
    cameraObject.y = (FlxG.mouse.y + player.y*3)/4;

    FlxG.collide(player, dungeon.collisionTilemap, function(a,b):Void { player.cancelDash(); });
    super.update();
    FlxG.collide(player, dungeon.collisionTilemap, function(a,b):Void { player.cancelDash(); });

    FlxG.collide(G.projectiles, dungeon.wallTilemap, function(a,b):Void {
      if(Std.is(a, ProjectileSprite)) a.onCollide();
    });

    dungeonObjects.sort(FlxSort.byY, FlxSort.ASCENDING);

  }
}

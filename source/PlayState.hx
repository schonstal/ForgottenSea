package;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.effects.FlxGlitchSprite;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;

import flixel.text.FlxText;

import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;

import flash.display.BlendMode;
import flash.geom.Point;
import flash.filters.ColorMatrixFilter;

class PlayState extends FlxState
{
  private var player:Player;
  private var reticle:Reticle;
  private var cameraObject:FlxObject;
  private var water:FlxSprite;
  private var spawnSprite:FlxSprite;
  private var spotlightSprite:FlxSprite;
  private var startPad:FlxSprite;
  private var exit:FlxSprite;
  private var exitTarget:FlxObject;

  private var dungeon:Dungeon;

  private var dungeonObjects:FlxTypedGroup<FlxObject>;
  private var projectiles:FlxTypedGroup<FlxObject>;
  private var torches:Torches;

  private var stageText:FlxText;

  private var playedSound:Bool = false;

  override public function create():Void {
    super.create();
    G.level++;
    G.torchLocations = new Array<FlxPoint>();
    Projectile.init();

    FlxG.camera.flash(0x181d23, 1);
    FlxG.mouse.visible = false;
    FlxG.debugger.drawDebug = true;
    FlxG.debugger.visible = true;

    var water = new Water();
    water.x = -FlxG.width/2;
    water.y = -FlxG.height/2;
    water.scrollFactor.x = water.scrollFactor.y = 0.2;
    add(water);

    dungeon = new Dungeon();
    add(dungeon);
    
    reticle = new Reticle();

    dungeonObjects = new FlxTypedGroup<FlxObject>();
    G.projectiles = new FlxTypedGroup<FlxObject>();

    startPad = new FlxSprite();
    startPad.loadGraphic("assets/images/spawn.png", false, 96, 96);
    startPad.animation.add("0", [0]);
    startPad.animation.add("1", [1]);
    startPad.animation.add("2", [2]);
    startPad.animation.add("3", [3]);
    startPad.animation.add("4", [3]);
    add(startPad);

    exit = new FlxSprite();
    exit.loadGraphic("assets/images/exit.png", false, 96, 96);
    exit.blend = BlendMode.ADD;
    exit.alpha = 0;
    exit.x = 44;
    exit.y = 54;
    exit.width = exit.height = 8;
    exit.offset.x = 44;
    exit.offset.y = 54;
    dungeonObjects.add(exit);

    exitTarget = new FlxObject();
    exitTarget.width = exitTarget.height = 2;
    exitTarget.x = exitTarget.y = 47;
    add(exitTarget);

    spotlightSprite = new FlxSprite();
    spotlightSprite.loadGraphic("assets/images/spotlight.png");
    spotlightSprite.x = 28;
    spotlightSprite.y = 62 - 480;
    spotlightSprite.blend = BlendMode.ADD;
    spotlightSprite.alpha = 0.2;
    add(spotlightSprite);

    player = new Player(dungeonObjects, reticle);
    player.x = 36;
    player.y = 0;
    dungeonObjects.add(player);

    torches = new Torches(dungeonObjects);

    add(dungeonObjects);

    add(dungeon.wallTopTilemap);

    spawnSprite = new FlxSprite();
    spawnSprite.loadGraphic("assets/images/spotlight_shaft.png");
    spawnSprite.x = spotlightSprite.x;
    spawnSprite.y = spotlightSprite.y;
    spawnSprite.blend = BlendMode.ADD;
    spawnSprite.alpha = 0.2;
    add(spawnSprite);

    stageText = new FlxText(0, FlxG.height/2-24, FlxG.width, "Seaside Caverns " + G.level, 16);
    stageText.alignment = "center";
    stageText.scrollFactor.x = stageText.scrollFactor.y = 0;
    stageText.alpha = 0;
    stageText.color = 0xffd9ece0;
    stageText.setBorderStyle(FlxText.BORDER_SHADOW, 0xff181d23, 2);
    add(stageText);

    cameraObject = new FlxObject();
    add(cameraObject);

    FlxG.camera.scroll.x = -FlxG.width/2 + 36;
    FlxG.camera.scroll.y = -FlxG.height/2 + 40;

    FlxTween.tween(player, { y: 40 }, 1, { ease: FlxEase.quadOut, complete: function(t) {
      player.started = true;
      new FlxTimer(1, function(t) {
        FlxTween.tween(spotlightSprite, { alpha: 0 }, 0.5, { ease: FlxEase.quadIn });
        FlxTween.tween(spawnSprite, { alpha: 0 }, 0.5, { ease: FlxEase.quadIn });
      });
    }});

    add(reticle);

    FlxG.camera.follow(cameraObject, FlxCamera.STYLE_LOCKON, new FlxPoint(-player.width/2,-player.height/2), 0);

    FlxG.worldBounds.width = FlxG.worldBounds.height = Dungeon.SIZE * 32;
    FlxG.worldBounds.x = dungeon.wallTilemap.x;
    FlxG.worldBounds.y = dungeon.wallTilemap.y;

    FlxG.sound.playMusic("assets/sounds/seacave_ambience1.wav", 0.25);
  }

  override public function update():Void {
    if(torches.lit >= 4) {
      if(exit.alpha == 0) {
        FlxTween.tween(exit, { alpha: 0.6 }, 0.5, { ease: FlxEase.quadOut, complete: function(t) {
          FlxTween.tween(exit, { alpha: 0.4 }, 1, { ease: FlxEase.quadInOut, type: FlxTween.PINGPONG });
        }});
      }

      if(FlxG.overlap(player, exitTarget)) {
        exitTarget.solid = false;
        player.started = false;
        FlxG.camera.fade(0x181d23, 1, false, function() {
          FlxG.switchState(new PlayState());
        });
      }

    }

    startPad.animation.play(""+torches.lit);
    cameraObject.x = (FlxG.mouse.x + player.x*3)/4;
    cameraObject.y = (FlxG.mouse.y + player.y*3)/4;

    FlxG.collide(player, dungeon.collisionTilemap, function(a,b):Void { player.cancelDash(); });
    super.update();
    FlxG.collide(player, dungeon.collisionTilemap, function(a,b):Void { player.cancelDash(); });

    FlxG.collide(G.projectiles, dungeon.wallTilemap, function(a,b):Void {
      if(Std.is(a, ProjectileSprite)) a.onCollide();
    });

    FlxG.collide(G.projectiles, torches, function(a,b):Void {
      if(Std.is(a, ProjectileSprite)) a.onCollide();
      if(Std.is(b, Torch)) b.onCollide();
    });

    FlxG.collide(player, torches);

    //TODO: Put this somewhere else
    if(!FlxG.overlap(player, startPad) && !playedSound) {
      FlxG.sound.play("assets/music/seacave_music1.wav", 0.9);
      playedSound = true;
      FlxTween.tween(stageText, { alpha: 1 }, 1, { ease: FlxEase.quartOut, complete: function(t) {
        new FlxTimer(1, function(t) {
          FlxTween.tween(stageText, { alpha: 0 }, 1, { ease: FlxEase.quartOut });
        });
      }});
      FlxTween.tween(FlxG.camera, 
                     { height: FlxG.height * 0.8, y: FlxG.height * 0.1 * FlxG.camera.zoom},
                     1,
                     { ease: FlxEase.quartOut, complete: function(t) {
                         new FlxTimer(1, function(t) {
                           FlxTween.tween(FlxG.camera,
                                          { height: FlxG.height, y: 0 },
                                          1,
                                          { ease: FlxEase.quartOut });
                         });
                       }
                     });
    }

    dungeonObjects.sort(FlxSort.byY, FlxSort.ASCENDING);
  }
}

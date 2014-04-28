package;

import flixel.group.FlxSpriteGroup;

import flixel.FlxSprite;
import flixel.FlxG;

import flixel.util.FlxRandom;
import flixel.util.FlxStringUtil;
import flixel.util.FlxVector;
import flixel.util.FlxTimer;

import flixel.tile.FlxTilemap;

class Projectile extends FlxSpriteGroup
{
  inline static var SPEED = 200;

  public var direction:FlxVector;

  static var projectiles:Array<Projectile> = new Array<Projectile>();

  var shadow:FlxSprite;
  var projectile:ProjectileSprite;
  var particles:Array<FlxSprite>;
  var particleGroup:FlxSpriteGroup;
  var explosionSprite:FlxSprite;

  public function new(X:Float, Y:Float):Void {
    super(X,Y);

    shadow = new FlxSprite();
    shadow.loadGraphic("assets/images/player_magic_shadow.png");
    shadow.offset.y = 3;
    shadow.offset.x = 1;
    shadow.solid = false;
    add(shadow);
    
    particles = new Array<FlxSprite>();
    particleGroup = new FlxSpriteGroup();
    add(particleGroup);

    projectile = new ProjectileSprite();
    projectile.onCollisionCallback = onCollide;
    add(projectile);

    G.projectiles.add(this);

    explosionSprite = new FlxSprite();
    explosionSprite.loadGraphic("assets/images/player_magic_hit.png", true, 64, 64);
    explosionSprite.animation.add("explode", [0,1,2,3,4,5], 20, false);
    explosionSprite.solid = false;
    add(explosionSprite);

    initialize(X,Y);
  }

  public function initialize(X:Float, Y:Float):Void {
    x = X;
    y = Y;
    projectile.x = X;
    projectile.y = Y;
    shadow.x = X;
    shadow.y = Y;

    exists = projectile.exists = shadow.exists = particleGroup.exists = explosionSprite.exists = true;
    spawnParticle();

    explosionSprite.visible = false;
    direction = new FlxVector(FlxG.mouse.x - projectile.x - 8, FlxG.mouse.y - projectile.y + 6).normalize();
    projectile.velocity.x = direction.x * SPEED;
    projectile.velocity.y = direction.y * SPEED;
    shadow.velocity = projectile.velocity;
  }

  private function spawnParticle():FlxSprite {
    var particle:FlxSprite = null;

    for (p in particles) {
      if (!p.exists) {
        p.exists = true;
        particle = p;
        break;
      }
    }

    if (particle == null) {
      particle = new FlxSprite();
      particle.loadGraphic("assets/images/player_magic_particle.png", false, 16, 16);
      particle.animation.add("fade", [0,1,2,2,3,3,4,4,4], 15, false);
      particle.animation.play("fade");
      particle.solid = false;
      new FlxTimer().start(0.6, function(t) { particle.exists = false; });
      particleGroup.add(particle);
    }

    particle.x = projectile.x + FlxRandom.intRanged(-5, 5) + 4;
    particle.y = projectile.y + FlxRandom.intRanged(-5, 5) - 12;
    particle.velocity.x = projectile.velocity.x/4;
    particle.velocity.y = projectile.velocity.y/4;

    new FlxTimer().start(0.1, function(t) { if(projectile.exists) spawnParticle(); });
    return particle;
  }

  public override function update():Void {
    super.update();
  }

  public function onCollide():Void {
    explosionSprite.x = projectile.x - 26;
    explosionSprite.y = projectile.y - 38;
    explosionSprite.visible = true;
    explosionSprite.animation.play("explode");
    new FlxTimer().start(6.0/20.0, function(t) { exists = false; });
    projectile.exists = shadow.exists = false;
    FlxG.camera.shake(0.02, 0.3);
    FlxG.sound.play("assets/sounds/orb_explode.wav");
  }

  public static function recycled(X:Float, Y:Float):Projectile {
    for(p in projectiles) {
      if(!p.exists) {
        p.initialize(X,Y);
        return p;
      }
    }

    var projectile:Projectile = new Projectile(X,Y);
    projectiles.push(projectile);
    return projectile;
  }
}

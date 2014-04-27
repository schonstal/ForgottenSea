package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.effects.FlxGlitchSprite;

class Water extends FlxSpriteGroup
{
  override public function new():Void {
    super();

    var water = new FlxSprite();
    water.loadGraphic("assets/images/water.png");

    var glitcher = new FlxGlitchSprite(water);
    add(glitcher);

    var waver = new FlxWaveSprite(glitcher);
	  waver.strength = 105;
    waver.center = 25;
    waver.speed = 3;
    add(waver);
  }
}

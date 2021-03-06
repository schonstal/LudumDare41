package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;

import flixel.math.FlxVector;
import flixel.math.FlxMath;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class EnemyGroup extends FlxSpriteGroup {
  var spawnTimer:Float = 0;
  var lastFallRow:Int = 0;

  var activeTween:FlxTween;
  var tweenPosition:Int = 0;
  var scrollTimer:Float = 0;
  var scrollRate:Float = 1;

  public function new() {
    super();
    spawnRow();
  }

  function spawnRow():Void {
    var percentage = FlxMath.lerp(0.4, 0.8, Reg.difficulty);

    var column:Int;
    for (column in 0...8) {
      if (Reg.random.float(0, 1) < percentage) {
        var e:Enemy = cast(recycle(Enemy), Enemy);
        e.spawn();
        e.initialize(column, onFall);
        add(e);
      }
    }

    Reg.spawnRow++;
  }

  function onFall(row:Int):Void {
    if(row <= lastFallRow) return;
    lastFallRow = row;

    scrollRate -= 0.1;
    if (scrollRate < 0.5) {
      scrollRate = 0.5;
    }
  }

  override public function update(elapsed:Float):Void {
    scrollTimer += elapsed;
    if (scrollTimer > scrollRate) {
      if (activeTween != null) activeTween.cancel();
      tweenPosition += 1;
      activeTween = FlxTween.tween(
        Reg,
        { scrollPosition: Enemy.ROW_HEIGHT * tweenPosition },
        0.25,
        { ease: FlxEase.quadOut }
      );

      scrollTimer = 0;
    }

    if (Reg.scrollPosition > Reg.spawnRow * Enemy.SPEED - 100) {
      spawnRow();
    }

    super.update(elapsed);
  }
}

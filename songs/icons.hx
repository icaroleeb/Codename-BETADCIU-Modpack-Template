//import flixel.tweens.FlxTween;

public var icoP1:HealthIcon;
public var icoP2:HealthIcon;

function postCreate() {
    icoP1 = new HealthIcon(boyfriend != null ? boyfriend.getIcon() : "face", true);
    icoP2 = new HealthIcon(dad != null ? dad.getIcon() : "face", false);
    for(ico in [icoP1, icoP2]) {
        ico.y = healthBar.y - (ico.height / 2) + 150;
        ico.cameras = [camHUD];
        insert(members.indexOf(healthBar) + 1, ico);
    }

    for (i in [iconP1, iconP2]) remove(i); // fuck you og icons

    if (icoP1.angle != 0) icoP1.angle = 0;
    FlxTween.tween(icoP1, {angle: 360}, 0.5, {ease: FlxEase.cubeOut});
}

function update(elapsed:Float){
    var mult:Float = FlxMath.lerp(1, icoP1.scale.x, Math.exp(-elapsed * 9));
    icoP1.scale.set(mult, mult);
    icoP1.updateHitbox();

    var mult:Float = FlxMath.lerp(1, icoP2.scale.x, Math.exp(-elapsed * 9));
    icoP2.scale.set(mult, mult);
    icoP2.updateHitbox();

    icoP1.offset.y = 150;
    icoP2.offset.y = 150;

    icoP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0)) - 26);
	icoP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0))) - (icoP2.width - 26);

    icoP1.health = healthBar.percent / 100;
    icoP2.health = 1 - (healthBar.percent / 100);
}

function beatHit(){
    icoP1.scale.set(1.2, 1.2);
    icoP2.scale.set(1.2, 1.2);
    icoP1.updateHitbox();
    icoP2.updateHitbox();
}
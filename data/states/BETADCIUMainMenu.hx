import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import funkin.backend.FunkinSprite;
import funkin.backend.FunkinText;
import flixel.text.FlxText.FlxTextBorderStyle;

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

var finishedFunnyMove:Bool = false;
var psychEngineVersion:String = '1.0.4';
var betadciuEngineVersion:String = "1.3.0";
var curSelected:Int = 0;
var curColumn = MainMenuColumn.CENTER;
var mainMusic:Bool = true;
var allowMouse:Bool = true;

var menuItems:FlxTypedGroup;
var menuItems2:FlxTypedGroup;
var leftItem:FunkinSprite;
var rightItem:FunkinSprite;

var optionShit:Array<String> = [
	'freeplay',
	'story_mode',
	'mods',
	'credits'
];

var leftOption:String = 'achievements';
var rightOption:String = 'options';

var magenta:FunkinSprite;
var bg:FunkinSprite;
var camFollow:FlxObject;
var selectedSomethin:Bool = false;
var timeNotMoving:Float = 0;
var savedY:Float = 0;

var pathDefault:String = 'menus/';

function create()
{
	persistentUpdate = persistentDraw = true;

	var yScroll:Float = 0.10;
	bg = new FunkinSprite(-80).loadGraphic(Paths.image(pathDefault + 'menuBG'));
    bg.antialiasing = true;
	bg.scrollFactor.set(0, yScroll);
	bg.setGraphicSize(Std.int(bg.width * 1.175));
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	camFollow = new FlxObject(-20, 0, 1, 1);
	add(camFollow);

	magenta = new FunkinSprite(-80).loadGraphic(Paths.image(pathDefault + 'menuDesat'));
	magenta.scrollFactor.set(0, yScroll);
	magenta.setGraphicSize(Std.int(magenta.width * 1.175));
	magenta.updateHitbox();
	magenta.screenCenter();
	magenta.visible = false;
	magenta.color = 0xFFfd719b;
	add(magenta);

	menuItems = new FlxTypedGroup();
	add(menuItems);

	menuItems2 = new FlxTypedGroup();
	add(menuItems2);

	for (num in 0...optionShit.length)
	{
		var option:String = optionShit[num];
		var item:FunkinSprite = createMenuItem(option, -630, (num * 140) + 90, 1);
		item.y += (4 - optionShit.length) * 70;
	}

	if (leftOption != null)
		leftItem = createMenuItem2(leftOption, FlxG.width - 247, 290, 0);
	
	if (rightOption != null)
	{
		rightItem = createMenuItem2(rightOption, FlxG.width - 60, 490, 0);
		rightItem.x -= rightItem.width;
	}

	var psychVer:FunkinText = new FunkinText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion + " Custom Build", 12);
	psychVer.scrollFactor.set();
	psychVer.setFormat(Paths.font("vcr.ttf"), 16, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(psychVer);

	var betadciuVer:FunkinText = new FunkinText(12, FlxG.height - 44, 0, "BETADCIU Engine Reworked v" + betadciuEngineVersion + " BETA", 12);
	betadciuVer.scrollFactor.set();
	betadciuVer.setFormat(Paths.font("vcr.ttf"), 16, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(betadciuVer);

	changeItem();
	FlxG.camera.follow(camFollow, null, 0.15);
}

function createMenuItem(name:String, x:Float, y:Float, daScroll:Float = 0):FunkinSprite
{
	var menuItem:FunkinSprite = new FunkinSprite(x, y);
	menuItem.frames = Paths.getSparrowAtlas(pathDefault + 'betadciu/menu_' + name);
	menuItem.animation.addByPrefix('idle', name + ' idle', 24, true);
	menuItem.animation.addByPrefix('selected', name + ' selected', 24, true);
	menuItem.animation.play('idle');
	menuItem.updateHitbox();
	
	menuItem.scrollFactor.set(daScroll, daScroll);
	menuItems.add(menuItem);
	return menuItem;
}

function createMenuItem2(name:String, x:Float, y:Float, daScroll:Float = 0):FunkinSprite
{
	var menuItem2:FunkinSprite = new FunkinSprite(x, y);
	menuItem2.frames = Paths.getSparrowAtlas(pathDefault + 'betadciu/menu_' + name);
	menuItem2.animation.addByPrefix('idle', name + ' idle', 24, true);
	menuItem2.animation.addByPrefix('selected', name + ' selected', 24, true);
	menuItem2.animation.play('idle');
	menuItem2.updateHitbox();
	
	menuItem2.scrollFactor.set(daScroll, daScroll);
	menuItems2.add(menuItem2);
	return menuItem2;
}

function update(elapsed:Float)
{
	if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

	if (!selectedSomethin)
	{
		var upP = controls.UI_UP_P || FlxG.keys.justPressed.UP;
		var downP = controls.UI_DOWN_P || FlxG.keys.justPressed.DOWN;
		var leftP = controls.UI_LEFT_P || FlxG.keys.justPressed.LEFT;
		var rightP = controls.UI_RIGHT_P || FlxG.keys.justPressed.RIGHT;
		var accepted = controls.ACCEPT || FlxG.keys.justPressed.ENTER;
		var back = controls.BACK || FlxG.keys.justPressed.ESCAPE;

        if (controls.DEV_ACCESS) {
            persistentUpdate = false;
            persistentDraw = true;
            openSubState(new funkin.editors.EditorPicker());
        }

		switch(curColumn)
		{
			case MainMenuColumn.CENTER:
				if (upP) changeItem(-1);
				if (downP) changeItem(1);
				if (rightP && leftOption != null) { curColumn = MainMenuColumn.LEFT; changeItem(); }
				if (leftP && rightOption != null) { curColumn = MainMenuColumn.RIGHT; changeItem(); }

			case MainMenuColumn.LEFT:
				if (upP || downP) { curColumn = MainMenuColumn.RIGHT; changeItem(); }
				if (rightP || leftP) { curColumn = MainMenuColumn.CENTER; changeItem(); }

			case MainMenuColumn.RIGHT:
				if (upP || downP) { curColumn = MainMenuColumn.LEFT; changeItem(); }
				if (leftP || rightP) { curColumn = MainMenuColumn.CENTER; changeItem(); }
		}

		if (back)
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new TitleState());
		}

		if (accepted)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			selectedSomethin = true;

			FlxFlicker.flicker(magenta, 1.1, 0.15, false);

			var item:FunkinSprite;
			var option:String;
			switch(curColumn)
			{
				case MainMenuColumn.CENTER:
					option = optionShit[curSelected];
					item = menuItems.members[curSelected];
				case MainMenuColumn.LEFT:
					option = leftOption;
					item = leftItem;
				case MainMenuColumn.RIGHT:
					option = rightOption;
					item = rightItem;
			}

			FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
			{
				switch (option)
				{
					case 'story_mode': FlxG.switchState(new StoryMenuState());
					case 'freeplay': FlxG.switchState(new FreeplayState());
					case 'mods': 
                        openSubState(new funkin.menus.ModSwitchMenu());
                        persistentUpdate = false;
                        persistentDraw = true;
					case 'achievements': FlxG.switchState(new AchievementsMenuState());
					case 'credits': FlxG.switchState(new CreditsState());
					case 'options': FlxG.switchState(new OptionsState());
				}
			});
			
			for (memb in menuItems.members)
			{
				if (memb == item) continue;
				FlxTween.tween(memb, {x: memb.x - 1200}, 0.8, {ease: FlxEase.backIn});
			}

			for (memb in menuItems2.members)
			{
				if (memb == item) continue;
				FlxTween.tween(memb, {x: memb.x + 1200}, 0.8, {ease: FlxEase.backIn});
			}
			
			FlxTween.tween(bg.scale, {x: 1.6, y: 1.6}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(magenta.scale, {x: 1.6, y: 1.6}, 1, {ease: FlxEase.quadOut});
		}
	}

	super.update(elapsed);
}

function changeItem(change:Int = 0)
{
	if (change != 0 && curColumn != MainMenuColumn.CENTER) curColumn = MainMenuColumn.CENTER;
	
	if (curColumn == MainMenuColumn.CENTER) {
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
	}

	FlxG.sound.play(Paths.sound('scrollMenu'));

	for (item in menuItems.members)
	{
		FlxTween.cancelTweensOf(item);
		FlxTween.tween(item, {x: -620}, 0.26, {ease: FlxEase.expoOut});
		item.animation.play('idle');
		item.centerOffsets();
	}

	for (item2 in menuItems2.members)
	{
		item2.animation.play('idle');
		item2.centerOffsets();
	}

	var selectedItem:FunkinSprite;
	switch(curColumn)
	{
		case MainMenuColumn.CENTER:
			selectedItem = menuItems.members[curSelected];
			FlxTween.cancelTweensOf(selectedItem);
			FlxTween.tween(selectedItem, {x: -440}, 0.26, {ease: FlxEase.expoOut});
		case MainMenuColumn.LEFT:
			selectedItem = leftItem;
		case MainMenuColumn.RIGHT:
			selectedItem = rightItem;
	}

	selectedItem.animation.play('selected');
	selectedItem.centerOffsets();

	if (selectedItem != leftItem && selectedItem != rightItem) {
		camFollow.y = selectedItem.getGraphicMidpoint().y;
		savedY = camFollow.y;
	}

	if (selectedItem == leftItem || selectedItem == rightItem) {
		camFollow.y = (curColumn == MainMenuColumn.RIGHT) ? savedY + 140 : savedY;
		camFollow.x = 140;
		FlxTween.cancelTweensOf(bg);
		FlxTween.cancelTweensOf(magenta);
		FlxTween.tween(bg, {x: -165.5}, 0.4, {ease: FlxEase.sineOut});
		FlxTween.tween(magenta, {x: -165.5}, 0.4, {ease: FlxEase.sineOut});
	} else {
		camFollow.x = -20;
		FlxTween.cancelTweensOf(bg);
		FlxTween.cancelTweensOf(magenta);
		FlxTween.tween(bg, {x: -115.5}, 0.4, {ease: FlxEase.sineOut});
		FlxTween.tween(magenta, {x: -115.5}, 0.4, {ease: FlxEase.sineOut});
	}
}
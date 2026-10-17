function onEvent(event) {
	if (event.event.name == "Change Character") {
		var slot:String = event.event.params[0];
		var charIndex:Int = event.event.params[1];
		var charID:String = event.event.params[2];

		var strumLineIndex:Int = switch(slot) {
			case "dad": 0;
			case "bf": 1;
			case "gf": 2;
			default: 0;
		};

		var strumLine = strumLines.members[strumLineIndex];
		if (strumLine != null) {

			while (strumLine.characters.length <= charIndex) {
				strumLine.characters.push(null);
			}

			var oldChar = strumLine.characters[charIndex];

            oldChar?.kill();
            oldChar?.destroy();

			var charPosName = slot == "bf" ? "boyfriend" : slot;
			var isFlipped = stage.isCharFlipped(
				stage.characterPoses[charID] != null ? charID : charPosName, 
				strumLineIndex == 1
			);

			var newChar = new Character(0, 0, charID, isFlipped);
			if (stage != null) stage.applyCharStuff(newChar, charPosName, charIndex);
			strumLine.characters[charIndex] = newChar;

			if (slot == "dad" && charIndex == 0) {
				if (icon2 != null && (icon2.visible || icon2.alpha != 0))
					icon2.setIcon(dad != null ? dad.getIcon() : Flags.DEFAULT_HEALTH_ICON);

				if (iconP2 != null && (iconP2.visible || iconP2.alpha != 0)) // codename icon compatible
					iconP2.setIcon(dad != null ? dad.getIcon() : Flags.DEFAULT_HEALTH_ICON);

				updateHealthBarColor();
			} else if (slot == "bf" && charIndex == 0) {
				if (icon1 != null && (icon1.visible || icon1.alpha != 0))
					icon1.setIcon(boyfriend != null ? boyfriend.getIcon() : Flags.DEFAULT_HEALTH_ICON);

				if (iconP1 != null && (iconP1.visible || iconP1.alpha != 0)) // codename icon compatible
					iconP1.setIcon(boyfriend != null ? boyfriend.getIcon() : Flags.DEFAULT_HEALTH_ICON);

				updateHealthBarColor();
			}
		}
	}
}

function updateHealthBarColor():Void
{
	var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
	healthBar.createFilledBar(leftColor, rightColor);
}
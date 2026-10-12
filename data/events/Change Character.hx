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

		var strumLine = PlayState.instance.strumLines.members[strumLineIndex];
		if (strumLine != null) {

			while (strumLine.characters.length <= charIndex) {
				strumLine.characters.push(null);
			}

			var oldChar = strumLine.characters[charIndex];

            oldChar?.kill();
            oldChar?.destroy();

			var charPosName = slot == "bf" ? "boyfriend" : slot;
			var isFlipped = PlayState.instance.stage.isCharFlipped(
				PlayState.instance.stage.characterPoses[charID] != null ? charID : charPosName, 
				strumLineIndex == 1
			);

			var newChar = new Character(0, 0, charID, isFlipped);
			PlayState.instance.stage.applyCharStuff(newChar, charPosName, charIndex);
			strumLine.characters[charIndex] = newChar;

			if (slot == "dad" && charIndex == 0) {
				PlayState.instance.icon2.changeIcon(newChar.getIcon());
				PlayState.instance.icon2.reloadColor();
			} else if (slot == "bf" && charIndex == 0) {
				PlayState.instance.icon1.changeIcon(newChar.getIcon());
				PlayState.instance.icon1.reloadColor();
			}
		}
	}
}
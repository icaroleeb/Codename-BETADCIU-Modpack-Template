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
				icon2.setIcon(newChar.getIcon());
			} else if (slot == "bf" && charIndex == 0) {
				icon1.setIcon(newChar.getIcon());
			}
		}
	}
}
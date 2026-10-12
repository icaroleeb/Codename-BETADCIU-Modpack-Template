import funkin.game.Character;
import funkin.game.StrumLine;

function makeChar(charId:String, isPlayer:Bool):Character
{
    return new Character(0, 0, charId, isPlayer, true, false);
}

function refreshHealthBar()
{
    if (healthBar == null || dad == null || boyfriend == null)
        return;

    var dadColor = dad.iconColor != null ? dad.iconColor : 0xFFFF0000;
    var bfColor = boyfriend.iconColor != null ? boyfriend.iconColor : 0xFF66FF33;

    healthBar.createFilledBar(dadColor, bfColor);
    healthBar.updateBar();
}

function refreshIcons()
{
    if (iconP2 != null && dad != null)
        iconP2.setIcon(dad.getIcon());

    if (iconP1 != null && boyfriend != null)
        iconP1.setIcon(boyfriend.getIcon());
}

function getStrumlineIndex(slot:String):Int
{
    for (i in 0...strumLines.members.length)
    {
        var line:StrumLine = strumLines.members[i];

        if (line == null)
            continue;

        switch (slot)
        {
            case "dad":
                // opponent side (ignore GF line)
                if (line.opponentSide && i != 2)
                    return i;

            case "bf":
                if (!line.opponentSide)
                    return i;

            case "gf":
                if (i == 2)
                    return i;
        }
    }

    return -1;
}

function getStageSlot(slot:String):String
{
    switch (slot)
    {
        case "dad":
            return "dad";

        case "bf":
            return "boyfriend";

        case "gf":
            return "girlfriend";
    }

    return slot;
}

function rebuildCharacterLayering(strumLine:StrumLine)
{
    if (strumLine == null || strumLine.characters == null)
        return;

    var chars = strumLine.characters.copy();

    // remove everyone first
    for (char in chars)
    {
        if (char != null)
            remove(char, false);
    }

    // add them back in order
    for (char in chars)
    {
        if (char != null)
            add(char);
    }
}

function replaceCharacter(slot:String, charIndex:Int, newCharId:String)
{
    var lineIndex = getStrumlineIndex(slot);

    if (lineIndex == -1)
        return;

    var strumLine:StrumLine = strumLines.members[lineIndex];

    if (strumLine == null || strumLine.characters == null)
        return;

    if (charIndex < 0 || charIndex >= strumLine.characters.length)
        return;

    var oldChar:Character = strumLine.characters[charIndex];

    if (oldChar == null)
        return;

    var isPlayer = slot == "bf";
    var newChar = makeChar(newCharId, isPlayer);

    // keep position + visual settings
    newChar.x = oldChar.x;
    newChar.y = oldChar.y;

    newChar.scrollFactor.set(
        oldChar.scrollFactor.x,
        oldChar.scrollFactor.y
    );

    newChar.alpha = oldChar.alpha;
    newChar.visible = oldChar.visible;

    // swap in array
    strumLine.characters[charIndex] = newChar;

    // remove old character
    remove(oldChar, true);

    // add new character
    add(newChar);

    // apply stage offsets
    stage.applyCharStuff(
        newChar,
        getStageSlot(slot),
        charIndex
    );

    // fix layering
    rebuildCharacterLayering(strumLine);

    // update globals
    switch (slot)
    {
        case "dad":
            if (charIndex == 0)
                dad = newChar;

        case "gf":
            if (charIndex == 0)
                gf = newChar;

        case "bf":
            if (charIndex == 0)
            {
                boyfriend = newChar;
                bf = boyfriend;
            }
    }

    refreshIcons();
    refreshHealthBar();
}

function onEvent(e)
{
    if (e.event.name != "Swap Character")
        return;

    var slot = Std.string(e.event.params[0]);

    var charIndex = Std.parseInt(
        Std.string(e.event.params[1])
    );

    var newCharId = Std.string(
        e.event.params[2]
    );

    replaceCharacter(slot, charIndex, newCharId);
}
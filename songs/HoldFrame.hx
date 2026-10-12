function postUpdate(elapsed:Float)
{
    if (strumLines == null) return;

    for (strumLine in strumLines.members)
    {
        if (strumLine == null || strumLine.characters == null) continue;

        for (char in strumLine.characters)
        {
            if (char == null || char.animation == null) continue;

            var anim = char.animation.curAnim;
            
            if (anim != null && anim.name.indexOf("sing") == 0 && anim.curFrame > 1)
            {
                if (isHoldingNote(strumLine))
                {
                    anim.curFrame = 0;
                }
            }
        }
    }
}

function isHoldingNote(strumLine:StrumLine):Bool
{
    if (strumLine.notes == null) return false;
    
    for (note in strumLine.notes.members)
    {
        if (note != null && note.isSustainNote && note.wasGoodHit && !note.tooLate)
        {
            var noteAnim = note.animation.curAnim;
            if (noteAnim != null && noteAnim.name != "holdend")
            {
                return true;
            }
        }
    }
    return false;
}
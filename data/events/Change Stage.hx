import funkin.game.Stage;

var stageToLoad:Array<String> = [];

function postCreate()
{
    for (event in PlayState.SONG.events){ // preload
        if (event.name == 'Change Stage')
        {
            for (stage in stageToLoad)
                switchStage(stage);

            switchStage(SONG.stage);

            trace("stage preload has been concluded");
        }
    }
}

function onEvent(s)
{
    var name = s.event.name;
    var getEventFrom = s.event.params;

    if (name == "Change Stage")
    {
        stageToLoad.push(getEventFrom[0]);
        switchStage(getEventFrom[0]);
    }
}

function switchStage(name:String)
{
    if (stage == null)
        return;

    gameAndCharsCall("onStageDestroy", [name]);

    for (sprite in stage.stageSprites) 
    {
        sprite?.kill();
        sprite?.destroy();
    }

    if (stage.stageScript != null) {
        stage.stageScript.call("destroy");

        scripts.remove(stage.stageScript);
        stage.stageScript.destroy();
    }

    remove(stage);
    stage.destroy();

    add(stage = new Stage(name));
    defaultCamZoom = stage.defaultZoom;

    if (comboGroup != null) {
        remove(comboGroup, true);
        add(comboGroup);
    }
  
    for (strLine in strumLines.members) {
        if (strLine.characters != null) {
            for (k => character in strLine.characters) {
                if (character == null) continue;

                remove(character);

                var baseCharPosName:String = switch(strLine.data.type) {
                    case 0: "dad";
                    case 1: "boyfriend";
                    case 2: "girlfriend";
                    default: "dad";
                };

                var charPos = stage.characterPoses[character.curCharacter] != null 
                    ? stage.characterPoses[character.curCharacter] 
                    : (stage.characterPoses[baseCharPosName + k] != null ? stage.characterPoses[baseCharPosName + k] : stage.characterPoses[baseCharPosName]);

                if (charPos != null) {
                    insert(members.indexOf(charPos), character);
                } else {
                    add(character);
                }
            }
        }
    }

    if (stage.stageScript != null) {
        stage.stageScript.call("create");
        stage.stageScript.call("postCreate");
    }
}
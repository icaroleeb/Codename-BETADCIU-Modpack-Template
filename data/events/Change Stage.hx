import funkin.game.Stage;

var stageToLoad:Array<String> = [];

function postCreate()
{
    if (stageToLoad > 0)
        return;

    for (stage in stageToLoad) // preload
        stageToLoad.push(getEventFrom[0]);

    switchStage(SONG.stage);
    trace("stage preload has been concluded");
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

                var charPosName:String = switch(strLine.data.type) {
                    case 0: "dad";
                    case 1: "boyfriend";
                    case 2: "girlfriend";
                    default: "dad";
                };

                stage.applyCharStuff(character, charPosName, k);
            }
        }
    }

    if (stage.stageScript != null) {
        stage.stageScript.call("create");
        stage.stageScript.call("postCreate");
    }
}
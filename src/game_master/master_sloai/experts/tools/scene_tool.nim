import times

import strformat

import ../../../../common/text
import ../../../../entities/scene

# Получает prompt для сцены
proc getScenePrompt*(scene: Scene): Text =
    var prompt = newText()
    # let time = scene.time.format("dd.MM.yyyy HH:mm:ss")
    # prompt.addLine(fmt"Сцена: {scene.description}")
    # prompt.addLine(fmt"Время: {time}")
    # prompt.addLine(fmt"Область действия: {scene.currentArea.description}")
    # prompt.addLine(fmt"Место действия: {scene.currentLocation.description}")
    # prompt.addLine(fmt"Персонажи:")
    # for pers in scene.currentPersons:
    #     prompt.add(getPersonPrompt(pers))
    
    return prompt
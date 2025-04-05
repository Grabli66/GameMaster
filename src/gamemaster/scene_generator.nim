import strformat

import ../entities/scene
import ../common/prompt
import ../gamemaster/person_generator

# Получает prompt для сцены
proc getScenePrompt*(scene: Scene): Prompt =
    var prompt = newPrompt()
    prompt.addLine(fmt"Сцена: {scene.description}")
    prompt.addLine(fmt"Время: {scene.time.toString(fmt: "dd.MM.yyyy HH:mm:ss")}")
    prompt.addLine(fmt"Область действия: {scene.currentArea.description}")
    prompt.addLine(fmt"Место действия: {scene.currentLocation.description}")
    prompt.addLine(fmt"Персонажи:")
    for pers in scene.currentPersons:
        prompt.add(getPersonPrompt(pers))
    
    return prompt
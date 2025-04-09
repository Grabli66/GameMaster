# Эксперт по рассказыванию историй

import strformat
import options

import ../../../ai_api/openai_api
import ../../../entities/game_book
import ../../../common/text
import ../common/story
import ./tools/scene_tool

const allowedModels = @["meta-llama/llama-4-maverick:free", "gemma34bIt"]

# Эксперт по рассказыванию историй
type StoryTellerExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по рассказыванию историй
proc newStoryTellerExpert*(apiCollection: ApiCollection): StoryTellerExpert =
    let (api, model) = apiCollection.getApi(allowedModels)
    return StoryTellerExpert(api: api, model: model)

# Создает пролог для истории
proc createPrologue*(self: StoryTellerExpert, gameBook: GameBook, story: Story): Text =
    # Создает описание сцены для вывода игроку
    var scenePrompt = newText()
    
    let time = gameBook.world.currentScene.time.format("dd.MM.yyyy HH:mm:ss")
    scenePrompt.addLine(fmt"Сцена: {gameBook.world.currentScene.description}")
    scenePrompt.addLine(fmt"Время: {time}")
    scenePrompt.addLine(fmt"Область действия: {gameBook.world.currentScene.currentArea.description}")
    scenePrompt.addLine(fmt"Место действия: {gameBook.world.currentScene.currentLocation.description}")
    prompt.addLine(fmt"Персонажи:")
    for pers in scene.currentPersons:
        prompt.add(getPersonPrompt(pers))

    scenePrompt.addLine(fmt"Художественно опиши начало сцены и персонажей без действий персонажей. Опиши главного персонажа.")
    let completeResult: string = self.api.complete(self.model, @[], @[scenePrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        stream: some(false)
    )))
    return newText(completeResult)


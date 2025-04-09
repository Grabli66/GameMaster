# Эксперт по рассказыванию историй

import strformat
import times
import strutils
import options

import ../../../ai_api/openai_api
import ../../../entities/game_book
import ../../../common/text
import ../common/story
import ./tools/scene_tool
import ../../../entities/person

const allowedModels = @["meta-llama/llama-4-maverick:free", "gemma34bIt"]

# Эксперт по рассказыванию историй
type StoryTellerExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Получает описание персонажа
proc getPersonDescription*(self: StoryTellerExpert, person: Person): Text =
    var prompt = newText()
    if person.isMain:
        prompt.addLine(fmt"{person.name} (главный персонаж)")
    else:
        prompt.addLine(fmt"{person.name}")

    prompt.addLine(fmt"Возраст: {person.age}")
    prompt.addLine(fmt"Пол: {person.sex}")
    let character = person.character.join(", ")
    prompt.addLine(fmt"Внешность: {person.look}")
    prompt.addLine(fmt"Характер: {character}")
    let motivation = person.motivation.join(", ")
    prompt.addLine(fmt"Хочет {motivation}")
    let memory = person.memory.join(", ")
    prompt.addLine(fmt"Помнит что: {memory}")
    return prompt

# Создает новый эксперт по рассказыванию историй
proc newStoryTellerExpert*(apiCollection: ApiCollection): StoryTellerExpert =
    let (api, model) = apiCollection.getApi(allowedModels)
    return StoryTellerExpert(api: api, model: model)

# Создает пролог для истории
proc createPrologue*(self: StoryTellerExpert, gameBook: GameBook, story: Story): Text =
    # Создает описание сцены для вывода игроку
    var scenePrompt = newText()
    
    let time = story.currentScene.time.format("dd.MM.yyyy HH:mm:ss")
    scenePrompt.addLine(fmt"Сцена: {story.currentScene.description}")
    scenePrompt.addLine(fmt"Время: {time}")
    scenePrompt.addLine(fmt"Область действия: {story.currentScene.currentArea.description}")
    scenePrompt.addLine(fmt"Место действия: {story.currentScene.currentLocation.description}")
    scenePrompt.addLine(fmt"Персонажи:")
    for pers in story.currentScene.currentPersons:
        scenePrompt.add(getPersonDescription(self, pers))

    scenePrompt.addLine(fmt"Художественно опиши начало сцены и персонажей без действий персонажей. Опиши главного персонажа.")
    let completeResult: string = self.api.complete(self.model, @[], @[scenePrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        stream: some(false)
    )))
    return newText(completeResult)


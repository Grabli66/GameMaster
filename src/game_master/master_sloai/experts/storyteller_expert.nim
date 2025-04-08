# Эксперт по рассказыванию историй

import strformat
import options

import ../../../ai_api/openai_api
import ../../../entities/game_book
import ../../../common/text
import ../common/story
import ./tools/scene_tool

const storyTellerModel = "gemma34bIt"

# Эксперт по рассказыванию историй
type StoryTellerExpert* = object
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по рассказыванию историй
proc newStoryTellerExpert*(model = storyTellerModel): StoryTellerExpert =
    return StoryTellerExpert(model: model)

# Создает пролог для истории
proc createPrologue*(self: StoryTellerExpert, awm: ApiWithModels, gameBook: GameBook, story: Story): Text =
    # Создает описание сцены для вывода игроку
    var scenePrompt = newText()
    scenePrompt.addLine(fmt"Художественно опиши начало сцены и персонажей без действий персонажей. Опиши главного персонажа.")
    let completeResult: string = awm.api.complete(self.model, @[], @[scenePrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        stream: some(false)
    )))
    return newText(completeResult)


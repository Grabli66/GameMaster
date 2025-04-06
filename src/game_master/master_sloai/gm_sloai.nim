# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import strformat
import options
import algorithm
import strutils

import ../../ai_api/openai_api
import ../../entities/[world, scene, person, location]
import ../../common/prompt
import location_tool
import person_tool
import scene_tool
import types

# Персонаж с действиями
type PersonWithActions = object
    # Персонаж
    person: Person
    # Действия персонажа
    action: seq[PersonAction]

# Тип для мастера игры
type GameMaster* = object
    # API с моделями
    api: ApiWithModels
    # Мир
    world:World        
    # Текущая сцена
    currentScene:Scene
    # Текущий Ввод пользователя
    userInput: string

# История сцены которую будет рассказывать мастер
type SceneStoryBatch* = object
    # Текст начала сцены
    startGameText*: string
    # Персонаж с действиями
    personWithActions*: seq[PersonWithActions]    

# Необходимые модели
const neededModels = @[
    types.gemma34bIt,    
]

# Оператор для вывода мастера игры
proc `$`*(gm:GameMaster): string =
    return fmt"Мастер игры: {gm.world}"

# Рассказывает про действия персонажей
proc tellActions*(gm:GameMaster, persWithActions: seq[PersonWithActions]):string =
    var systemPrompt = newPrompt()
    systemPrompt.addLine("Ты мастер игры. Ты отвечаешь за проведение сцены.")

    var scenePrompt = getScenePrompt(gm.currentScene)
    for persWithAction in persWithActions:
        scenePrompt.addLine(fmt"Персонаж : {persWithAction.person.name}")
        for action in persWithAction.action:
            scenePrompt.addLine(fmt"Действие: {action}")

    return ""

# Получает ощущения персонажа
proc getSensoryPersonPerception(gm:GameMaster, person: Person): string =    
    var userPrompt = newPrompt()
    userPrompt.addLine(gm.currentScene.currentLocation.description)
    userPrompt.addLine(fmt"Ты {getPersonPrompt(person).toString()}.")
    userPrompt.addLine(fmt"Опиши что персонаж видит и чувствует в данный момент.")
    let completeResult = gm.api.complete(types.gemma34bIt, @[], @[userPrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        maxTokens: some(300),
        stream: some(false)
    )))
    return completeResult

# Тип для действий персонажа
proc getPersonActions(gm:GameMaster, ssb: SceneStoryBatch, pers: Person): seq[PersonAction] =
    let sensoryPerception= gm.getSensoryPersonPerception(pers)
    echo sensoryPerception
    # let prompt = "Придумай произвольные действия для персонажа " & person.Name & " " & $person.Age & " " & $person.Character    
    # let completeResult = ai.complete(@["Ты рассказчик"], @[prompt])

    # let actionsJson = parseJson(completeResult)
    # let actions = to(actionsJson, seq[PersonAction])
    return @[] #actions

# Создает нового мастера игры
proc newGameMaster*(ai: OpenAiApi, world:World, currentScene:Scene):GameMaster =
    let models = ai.getModels()
    
    # Проверяет наличие необходимых моделей
    var foundModels = newSeq[string]()
    for neededModel in neededModels:
        if neededModel in models:
            foundModels.add(neededModel)
    
    if foundModels.len == 0:
        raise newException(ValueError, "Не найдены необходимые модели. Требуются: " & neededModels.join(", "))            

    result = GameMaster(
        api: ApiWithModels(api: ai, models: foundModels), 
        world: world, 
        currentScene: currentScene
    )

# Запускает игру и возвращает описание сцены
proc startGame*(gm: var GameMaster):SceneStoryBatch =
    # Создает описание локации
    let locationDescription = createLocationDescription(gm.api, gm.currentScene.currentLocation, maxTokens = 500)        
    gm.currentScene.currentLocation.description = locationDescription
        
    # Создает описание сцены для вывода игроку
    var scenePrompt: Prompt = getScenePrompt(gm.currentScene)
    scenePrompt.addLine(fmt"Художественно опиши начало сцены и персонажей без действий персонажей. Опиши главного персонажа.")
    let completeResult: string = gm.api.complete(types.gemma34bIt, @[], @[scenePrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        stream: some(false)
    )))

    return SceneStoryBatch(
        startGameText: completeResult,
        personWithActions: @[]
    )

# Начинает сцену
# Кидает инициативу персонажам
# Сортирует персонажей по инициативе
proc beginScene*(gm: var GameMaster, ssb: var SceneStoryBatch) =
    # Кидает инициативу персонажам
    var persWithInitiative = newSeq[(Person, int)]()
    for pers in gm.currentScene.currentPersons:
        if pers.isMain:
            persWithInitiative.add((pers, 0))

        persWithInitiative.add((pers, pers.throwInitiative()))

    # Сортирует персонажей по инициативе
    persWithInitiative.sort(proc(a, b: (Person, int)): int =
        return a[1] - b[1])
    
    var persWithActions = newSeq[PersonWithActions]()

    for pers in persWithInitiative:
        # Прерывает цикл если персонаж главный
        if pers[0].isMain:
            break

        persWithActions.add(
            PersonWithActions(
                person: pers[0], 
                action: gm.getPersonActions(ssb, pers[0])))
    
    ssb.personWithActions = persWithActions

# Устанавливает ввод пользователя
proc setUserInput*(gm: GameMaster, ssb: var SceneStoryBatch, input: string) =
    # Разбивает ввод на атомарные действия
    discard

# Завершает сцену и возвращает историю сцены
proc endScene*(gm: GameMaster, ssb: var SceneStoryBatch) : string =
    discard

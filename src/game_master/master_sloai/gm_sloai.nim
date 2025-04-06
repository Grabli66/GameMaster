# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import strformat
import options
import algorithm

import ../../ai_api/openai_api
import ../../entities/[world, scene, person, location]
import ../../common/prompt
import location_generator
import person_generator
import scene_generator
import types

# Персонаж с действиями
type PersonWithActions = object
    # Персонаж
    person: Person
    # Действия персонажа
    action: seq[PersonAction]

# Тип для мастера игры
type GameMaster* = object
    # AI API
    ai: ApiWithModel
    # Мир
    world:World        
    # Текущая сцена
    currentScene:Scene
    # Текущий Ввод пользователя
    userInput: string

# История сцены которую будет рассказывать мастер
type SceneStoryBatch* = object
    # Текст начала сцены
    startGameText: string
    # Мастер игры
    gameMaster: GameMaster
    # Персонаж с действиями
    personWithActions: seq[PersonWithActions]    

# Допустимые модели
const allowedModels = @[
    "gemma-3-4b-it",
    "ruadaptqwen2.5-14b-instruct-1m"
]

# Оператор для вывода мастера игры
proc `$`*(gm:GameMaster): string =
    return fmt"Мастер игры: {gm.world}"

# Получает текст начала сцены
proc getStartGameText*(ssb: SceneStoryBatch): string =
    return ssb.startGameText

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
    let systemPrompt = getPersonPrompt(person)    
    var prompt = getScenePrompt(gm.currentScene)
    let completeResult = gm.ai.api.complete(gm.ai.model, systemPrompt, prompt, some(CompleteOptions(
        temperature: some(0.08),
        maxTokens: some(500),
        stream: some(false)
    )))
    return completeResult

# Тип для действий персонажа
proc getPersonActions(gm:GameMaster, pers: Person): seq[PersonAction] =
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
    var model: string
    for allowedModel in allowedModels:
        if allowedModel in models:
            model = allowedModel
            break
    
    if model.len == 0:
        raise newException(ValueError, "Не найдена подходящая модель")
    
    let apiWithModel = ApiWithModel(model: model, api: ai)

    result = GameMaster(ai: apiWithModel, world: world, currentScene: currentScene)

# Запускает игру и возвращает описание сцены
proc startGame*(gm: var GameMaster):SceneStoryBatch =
    # Создает описание локации
    let locationDescription = createLocationDescription(gm.ai, gm.currentScene.currentLocation, maxTokens = 500)        
    gm.currentScene.currentLocation.description = locationDescription
        
    var scenePrompt: Prompt = getScenePrompt(gm.currentScene)
    scenePrompt.addLine(fmt"Художественно опиши начало сцены и персонажей без действий персонажей. Опиши главного персонажа.")
    let completeResult: string = gm.ai.api.complete(gm.ai.model, @[], @[scenePrompt.toString()], some(CompleteOptions(
        temperature: some(0.0),
        stream: some(false)
    )))

    return SceneStoryBatch(
        startGameText: completeResult,
        gameMaster: gm,
        personWithActions: @[]
    )

# Начинает сцену
# Кидает инициативу персонажам
# Сортирует персонажей по инициативе
proc beginScene*(ssb: var SceneStoryBatch) =
    # Кидает инициативу персонажам
    var persWithInitiative = newSeq[(Person, int)]()
    for pers in ssb.gameMaster.currentScene.currentPersons:
        persWithInitiative.add((pers, pers.throwInitiative()))

    # Сортирует персонажей по инициативе
    persWithInitiative.sort(proc(a, b: (Person, int)): int =
        return a[1] - b[1])
    
    var persWithActions: seq[PersonWithActions] = newSeq[PersonWithActions]()

    for pers in persWithInitiative:
        # Прерывает цикл если персонаж главный
        if pers[0].isMain:
            break

        persWithActions.add(
            PersonWithActions(
                person: pers[0], 
                action: ssb.gameMaster.getPersonActions(pers[0])))
    
    ssb.personWithActions = persWithActions

# Устанавливает ввод пользователя
proc setUserInput*(ssb: var SceneStoryBatch, input: string) =
    # Разбивает ввод на атомарные действия
    discard

# Завершает сцену и возвращает историю сцены
proc endScene*(ssb: var SceneStoryBatch) : string =
    discard

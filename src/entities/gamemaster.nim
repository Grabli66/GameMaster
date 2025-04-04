import ../ai_api/[types, ai_api]
import strformat
import options
import algorithm

import world
import scene
import person
import ../common/prompt

# Персонаж с действиями
type PersonWithActions = object
    # Персонаж
    person: Person
    # Действия персонажа
    action: seq[PersonAction]

# Тип для мастера игры
type GameMaster* = object
    # Мир
    world:World        
    # Текущая сцена
    currentScene:Scene
    # Текущий Ввод пользователя
    userInput: string

# История сцены которую будет рассказывать мастер
type SceneStoryBatch* = object
    # Мастер игры
    gameMaster: GameMaster
    # Персонаж с действиями
    personWithActions: seq[PersonWithActions]    

# Оператор для вывода мастера игры
proc `$`*(gm:GameMaster): string =
    return fmt"Мастер игры: {gm.world}"

# Рассказывает про действия персонажей
proc tellActions*(gm:GameMaster, persWithActions: seq[PersonWithActions]):string =
    let ai = ai_api.get()
    var systemPrompt = newPrompt()
    systemPrompt.addLine("Ты мастер игры. Ты отвечаешь за проведение сцены.")

    var scenePrompt = gm.currentScene.getPrompt()
    for persWithAction in persWithActions:
        scenePrompt.addLine(fmt"Персонаж : {persWithAction.person.name}")
        for action in persWithAction.action:
            scenePrompt.addLine(fmt"Действие: {action}")

    return ""

# Получает ощущения персонажа
proc getSensoryPersonPerception(gm:GameMaster, person: Person): string =
    let ai = ai_api.get()
    let systemPrompt = person.getPrompt()    
    var prompt = gm.currentScene.getPrompt()
    let completeResult = ai.complete(systemPrompt, prompt)
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
proc newGameMaster*(world:World, currentScene:Scene):GameMaster =
    result = GameMaster(world: world, currentScene: currentScene)

# Запускает игру и возвращает описание сцены
proc startGame*(gm:GameMaster):string =
    let ai = ai_api.get()
    var systemPrompt = newPrompt()
    systemPrompt.addLine("Ты мастер игры. Ты отвечаешь за проведение сцены.")    
    
    var scenePrompt = gm.currentScene.getPrompt()
    scenePrompt.addLine(fmt"Игра начинается. Кратко расскажи где происходит действие. Расскажи про персонажей.")
    let completeResult = ai.complete(systemPrompt, scenePrompt, some(CompleteOptions(
        temperature: some(0.08),
        maxTokens: some(500),
        stream: some(false)
    )))
    return completeResult

# Начинает сцену
# Кидает инициативу персонажам
# Сортирует персонажей по инициативе
proc beginScene*(gm:GameMaster) : SceneStoryBatch =
    # Кидает инициативу персонажам
    var persWithInitiative = newSeq[(Person, int)]()
    for pers in gm.currentScene.currentPersons:
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
                action: gm.getPersonActions(pers[0])))

    return SceneStoryBatch(
        gameMaster: gm,
        personWithActions: persWithActions)

# Устанавливает ввод пользователя
proc setUserInput*(ssb:SceneStoryBatch, input: string) =
    # Разбивает ввод на атомарные действия

    discard

# Завершает сцену и возвращает историю сцены
proc endScene*(ssb:SceneStoryBatch) : string =
    discard

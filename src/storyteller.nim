import times

import entities/[person, world, area, scene, location, coordinates, game_book]
import game_master/master_sloai/game_master_sloai as gm
import game_master/master_sloai/game_master_sloai_builder as gmb
import ai_api/openai_api
import common/text
import common/privateSettings
when isMainModule:

    let wrld = newWorld(description = "Наш реальный мир 2025 года", areas = @[
        newArea(name = "Владимир", description = "Столица Владимирской области. Город с большим количеством исторических зданий и музеев.", locations = @[
             newLocation(name = "Продуктовый магазин", description = "Небольшой продуктовый магазин \"У дома\" на окраине города Владимир", coordinates = newCoordinates(56.1287, 40.4083)),
         ])
    ])

    let book = newGameBook(
        name = "Лиза 1824 г.", 
        world = wrld, 
        persons = @[
            newPerson(
                isMain = false,
                name = "Елена Сергеевна Морозова", 
                age = 46, 
                sex = "женщина",
                look = "Высокая, худощавая, с короткими черными волосами",
                character = newText("Нервная", "Смелая", "Грубая"), 
                motivation = newText("Выжить" ,"Уйти быстрее с работы"), 
                memory = newText("Продавщица в продуктовом магазине \"У дома\"")),
            newPerson(
                isMain = true,
                name = "Краснова Инна Васильевна", 
                age = 32, 
                sex = "женщина",
                look = "Высокая, худощавая, с короткими черными волосами",
                character = @["Добрая", "Слабая", "Смелая"], 
                motivation = @["Выжить" ,"Купить еды"], 
                memory = newText("Пришла после работы в магазин купить еду, потому что дома нет еды")),
        ], 
        rules = @[]
    )
    
    var ai = openai_api.newOpenAiApi("https://openrouter.ai/api")
    ai.addBearerToken(privateSettings.openRouterApiKey)

    # let models = ai.getModels()
    let aiWithModels = newApiWithModels(ai, @["meta-llama/llama-4-maverick:free"])

    let apiSources = newApiCollection(aiWithModels)

    let startScene = newScene(
        "Сцена 1", 
        "Инна в продуктовом магазине", 
        dateTime(2025, mApr, 4, 17, 33, 0, 0, utc()),
        wrld.areas[0], 
        wrld.areas[0].locations[0], book.persons)

    let gmBuilder = gmb.newGameMasterSloaiBuilder(apiSources, book, startScene)
    var gameMaster = gmBuilder.build()
    let story = gameMaster.startGame()
    echo story.lastText.toString()

    # var gm = gamemaster.newGameMaster(
    #     ai,
    #     wrld, 
    #     newScene(
    #         "Сцена 1", 
    #         "Инна в продуктовом магазине", 
    #         dateTime(2025, mApr, 4, 17, 33, 0, 0, utc()),
    #         wrld, 
    #         wrld.areas[0], 
    #         wrld.areas[0].locations[0], 
    #         wrld.persons))
    
    # # Начинает игру и выводит начало сцены
    # var story = gm.startGame()
    # echo story.lastText.toString()    

    # while true:
    #     # Итерирует сцену и выводит происходящее на ней
    #     story = gm.iterateScene(story)
    #     let input = readLine(stdin)
    #     if input == "exit":
    #         break

    #     gm.setUserInput(story, input)
    #     echo story.lastText.toString()

import times

import entities/[person, world, area, scene, location, coordinates]
import game_master/master_sloai/gm_sloai as gamemaster
import ai_api/openai_api

when isMainModule:
    let wrld = newWorld("Наш реальный мир 2025 года", @[
        newArea("Владимир", "Столица Владимирской области. Город с большим количеством исторических зданий и музеев.", @[
            newLocation("Продуктовый магазин", "Небольшой продуктовый магазин \"У дома\" на окраине города Владимир", newCoordinates(56.1287, 40.4083)),
        ])
    ], @[
        newPerson(
            isMain = false,
            name = "Елена Сергеевна Морозова", 
            age = 46, 
            sex = "женщина",
            look = "Высокая, худощавая, с короткими черными волосами",
            character = @["Нервная", "Смелая", "Грубая"], 
            motivation = @["Выжить" ,"Уйти быстрее с работы"], 
            memory = @["Продавщица в продуктовом магазине \"У дома\""]),
        newPerson(
            isMain = true,
            name = "Краснова Инна Васильевна", 
            age = 32, 
            sex = "женщина",
            look = "Высокая, худощавая, с короткими черными волосами",
            character = @["Добрая", "Слабая", "Смелая"], 
            motivation = @["Выжить" ,"Купить еды"], 
            memory = @["Пришла после работы в магазин купить еду, потому что дома нет еды"]),
    ])

    let ai = openai_api.newOpenAiApi("http://localhost:1234")

    var gm = gamemaster.newGameMaster(
        ai,
        wrld, 
        newScene(
            "Сцена 1", 
            "Инна в продуктовом магазине", 
            dateTime(2025, mApr, 4, 17, 33, 0, 0, utc()),
            wrld, 
            wrld.areas[0], 
            wrld.areas[0].locations[0], 
            wrld.persons))
    
    # Начинает игру и выводит начало сцены
    var ssb = gm.startGame()
    echo ssb.startGameText    

    while true:
        # Итерирует сцену и выводит происходящее на ней
        gm.beginScene(ssb)
        let input = readLine(stdin)
        if input == "exit":
            break

        gm.setUserInput(ssb, input)
        let story = gm.endScene(ssb)
        echo story

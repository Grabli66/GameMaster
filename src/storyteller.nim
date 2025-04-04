import times

import entities/[person, world, area, scene, location, coordinates]
import gamemaster/gamemaster

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
            look = "Высокая, худощавая, с короткими черными волосами",
            character = @["Нервная", "Смелая", "Грубая"], 
            motivation = @["Выжить" ,"Уйти быстрее с работы"], 
            memory = @["Продавщица в продуктовом магазине \"У дома\""]),
        newPerson(
            isMain = true,
            name = "Краснова Инна Васильевна", 
            age = 32, 
            look = "Высокая, худощавая, с короткими черными волосами",
            character = @["Добрая", "Слабая", "Смелая"], 
            motivation = @["Выжить" ,"Купить еды"], 
            memory = @["Пришла после работы в магазин купить еду, потому что дома нет еды"]),
    ])

    var gm = newGameMaster(
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
    echo ssb.getStartGameText()    

    # while true:
    #     # Итерирует сцену и выводит происходящее на ней
    #     ssb.beginScene()
    #     let input = readLine(stdin)
    #     if input == "exit":
    #         break

    #     ssb.setUserInput(input)
    #     let story = ssb.endScene()
    #     echo story

import times

import entities/[person, world, area, gamemaster, scene]

when isMainModule:
    let wrld = newWorld("Наш реальный мир 2025 года", @[
        newArea("Владимир", "Столица Владимирской области. Город с большим количеством исторических зданий и музеев.", @[
            newLocation("Продуктовый магазин", "Небольшой продуктовый магазин на окраине города", newCoordinates(56.1287, 40.4083)),            
        ])
    ], @[
        newPerson(
            isMain = true,
            name = "Краснова Инна Васильевна", 
            age = 46, 
            character = @["Добрая", "Слабая", "Смелая"], 
            motivation = @["Выжить" ,"Купить еды"], 
            memory = @["Пришла после работы в магазин купить еду, потому что дома нет еды"]),
    ])

    let gm = newGameMaster(
        wrld, 
        newScene(
            "Сцена 1", 
            "Иван и Петр стоят на красной площади и смотрят на Кремль", 
            dateTime(2025, mApr, 4, 17, 33, 0, 0, utc()),
            wrld, 
            wrld.areas[0], 
            wrld.areas[0].locations[0], 
            wrld.persons))
    
    # Начинает игру и выводит начало сцены
    echo gm.startGame()

    while true:
        # Итерирует сцену и выводит происходящее на ней
        let ssb = gm.beginScene()        
        let input = readLine(stdin)
        if input == "exit":
            break

        ssb.setUserInput(input)
        let story = ssb.endScene()
        echo story

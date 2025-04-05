import strformat
import times

import world
import person
import area
import location
import ../common/prompt

# Сцена для game master
type Scene* = object
    # Имя сцены
    name*: string
    # Описание сцены
    description*: string
    # Время сцены
    time*: DateTime
    # Мир
    world*: World
    # Текущая область
    currentArea*: Area
    # Текущее местоположение
    currentLocation*: Location
    # Текущие персонажи
    currentPersons*: seq[Person]   

# Оператор для вывода сцены
proc `$`*(scene: Scene): string =
    return fmt"Сцена: {scene.name} {scene.description} {scene.world} {scene.currentLocation} {scene.currentPersons}"

# Создает новую сцену
proc newScene*(
        name:string, 
        description:string, 
        time: DateTime,
        world:World, 
        currentArea:Area, 
        currentLocation:Location, 
        currentPersons:seq[Person]): Scene =
    result = Scene(
        name: name, 
        description: description, 
        time: time,
        world: world, 
        currentArea: currentArea, 
        currentLocation: currentLocation, 
        currentPersons: currentPersons)
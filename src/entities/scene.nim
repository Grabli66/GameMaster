import times
import strformat

import person
import area
import location

# Сцена на которой происходит действие
type Scene* = object
    # Имя сцены
    name*: string
    # Описание сцены
    description*: string
    # Время сцены
    time*: DateTime
    # Текущая область
    currentArea*: Area
    # Текущее местоположение
    currentLocation*: Location
    # Персонажи на сцене
    currentPersons*: seq[Person]

# Оператор для вывода сцены
proc `$`*(scene: Scene): string =
    return fmt"Сцена: {scene.name} {scene.description} {scene.currentLocation} {scene.currentPersons}"

# Создает новую сцену
proc newScene*(
        name:string, 
        description:string, 
        time: DateTime,
        currentArea:Area, 
        currentLocation:Location, 
        currentPersons:seq[Person]): Scene =
    result = Scene(
        name: name, 
        description: description, 
        time: time,
        currentArea: currentArea, 
        currentLocation: currentLocation, 
        currentPersons: currentPersons)
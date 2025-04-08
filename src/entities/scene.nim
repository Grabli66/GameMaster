import times
import strformat

import world
import person
import area
import location
import game_book

# Сцена на которой происходит действие
type Scene* = object
    # Имя сцены
    name*: string
    # Описание сцены
    description*: string
    # Время сцены
    time*: DateTime
    # Книга с историей
    book*: GameBook
    # Текущая область
    currentArea*: Area
    # Текущее местоположение
    currentLocation*: Location
    # Персонажи на сцене
    currentPersons*: seq[Person]

# Оператор для вывода сцены
proc `$`*(scene: Scene): string =
    return fmt"Сцена: {scene.name} {scene.description} {scene.book} {scene.currentLocation} {scene.currentPersons}"

# Создает новую сцену
proc newScene*(
        name:string, 
        description:string, 
        time: DateTime,
        book:GameBook, 
        currentArea:Area, 
        currentLocation:Location, 
        currentPersons:seq[Person]): Scene =
    result = Scene(
        name: name, 
        description: description, 
        time: time,
        book: book, 
        currentArea: currentArea, 
        currentLocation: currentLocation, 
        currentPersons: currentPersons)
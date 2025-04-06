import strformat

import area
import person

# Тип для мира
type World* = object
    # Описание мира
    description*: string
    # Области в мире
    areas*: seq[Area]
    # Персонажи в мире
    persons*: seq[Person]

# Оператор для вывода мира
proc `$`*(world: World): string =
    return fmt"Мир: {world.description} {world.areas} {world.persons}"

# Создает новый мир
proc newWorld*(description:string, areas:seq[Area], persons:seq[Person]): World =
    result = World(description: description, areas: areas, persons: persons)


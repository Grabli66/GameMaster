import strformat

import area

# Описывает объект мира и локации в нем
type World* = object
    # Описание мира
    description*: string
    # Области в мире
    areas*: seq[Area]

# Оператор для вывода мира
proc `$`*(world: World): string =
    return fmt"Мир: {world.description} {world.areas}"

# Создает новый мир
proc newWorld*(description:string, areas:seq[Area]): World =
    result = World(description: description, areas: areas)


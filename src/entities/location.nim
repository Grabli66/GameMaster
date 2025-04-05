import strformat

import coordinates
import ../common/prompt

# Тип для местоположения
type Location* = object
    # Имя местоположения
    name*: string
    # Описание местоположения
    description*: string
    # Координаты местоположения
    coordinates*: Coordinates

# Создает новое местоположение
proc newLocation*(name:string, description:string, coordinates:Coordinates): Location =
    result = Location(name: name, description: description, coordinates: coordinates)

# Клонирует местоположение с новым описанием
proc cloneWithDescription*(location: Location, description: string): Location =
    result = Location(name: location.name, description: description, coordinates: location.coordinates)

# Получает prompt для местоположения
proc getPrompt*(location: Location): Prompt =
    var prompt = newPrompt()
    prompt.addLine(fmt"Местоположение: {location.name}. {location.description}")
    return prompt

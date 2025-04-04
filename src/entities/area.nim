import strformat

# Тип для координат
type Coordinates* = object
    # Широта
    latitude*: float
    # Долгота
    longitude*: float

# Тип для местоположения
type Location* = object
    # Имя местоположения
    name*: string
    # Описание местоположения
    description*: string
    # Координаты местоположения
    coordinates*: Coordinates

# Тип для области
type Area* = object
    # Имя области
    name*: string
    # Описание области
    description*: string
    # Под-области. Например: область может состоять из нескольких районов, в районах могут быть города, в городах могут быть улицы
    areas*: seq[Area]
    # Местоположения в области которые можно посетить
    locations*: seq[Location]

# Оператор для вывода местоположения
proc `$`*(location: Location): string =
    return fmt"Местоположение: {location.name} {location.description} {location.coordinates}"

# Оператор для вывода области
proc `$`*(area: Area): string =
    return fmt"Область: {area.name} {area.description} {area.locations}"

# Создает новую область
proc newArea*(name:string, description:string, locations:seq[Location]): Area =
    result = Area(name: name, description: description, locations: locations)

# Создает новое местоположение
proc newLocation*(name:string, description:string, coordinates:Coordinates): Location =
    result = Location(name: name, description: description, coordinates: coordinates)

# Создает новые координаты
proc newCoordinates*(latitude:float, longitude:float): Coordinates =
    result = Coordinates(latitude: latitude, longitude: longitude)

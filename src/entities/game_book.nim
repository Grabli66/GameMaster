import world
import person

# Книга которую использует Game Master
type GameBook* = object
    # Название книги
    name*: string
    # Мир в котором происходит книга
    world*: World
    # Действующие лица в книге
    persons*: seq[Person]
    # Правила игры
    rules*: seq[string]
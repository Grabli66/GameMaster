# Тип для видов действий персонажа
type PersonActionKind* = enum
    # Действие, которое требует ответа от игрока
    talk
    # Действие, которое не требует ответа от игрока
    action

# Тип для действий персонажа
type PersonAction* = object
    case kind: PersonActionKind
    of PersonActionKind.talk:
        talk: string
    of PersonActionKind.action:
        action: string

# Тип персонажа
type Person* = object
    # Является ли персонаж главным
    isMain*: bool
    # Имя персонажа
    name*: string
    # Пол персонажа
    sex*: string
    # Возраст персонажа
    age*: int
    # Внешность персонажа
    look*: string
    # Характеристики персонажа
    character*: seq[string]
    # Мотивация персонажа: инстинкты, желания, цели
    motivation*: seq[string]
    # Память персонажа
    memory*: seq[string]

# Создает нового персонажа
proc newPerson*(
        isMain:bool,
        name:string, 
        sex:string,
        age:int, 
        look:string,
        character:seq[string], 
        motivation:seq[string], 
        memory:seq[string]):Person =
    result = Person(
        isMain: isMain,
        name: name, 
        sex: sex,
        age: age, 
        look: look,
        character: character, 
        motivation: motivation, 
        memory: memory)

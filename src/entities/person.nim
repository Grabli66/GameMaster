import ../common/text

# Тип для видов действий персонажа
type PersonActionKind* = enum
    # Действие, которое требует ответа от игрока
    talk
    # Действие за исключением разговора, передвижения, сна
    action
    # Действие передвижения
    move
    # Действие сна
    sleep

# Тип для действий персонажа
type PersonAction* = object
    case kind: PersonActionKind    
    of PersonActionKind.talk:
        talk: string    
    of PersonActionKind.action:
        action: string
    of PersonActionKind.move:
        move: string
    of PersonActionKind.sleep:
        sleep: string

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
    character*: Text
    # Мотивация персонажа: инстинкты, желания, цели
    motivation*: Text
    # Память персонажа
    memory*: Text

# Персонаж с действиями
type PersonWithActions* = object
    # Персонаж
    person: Person
    # Действия персонажа
    action: seq[PersonAction]

# Создает нового персонажа
proc newPerson*(
        isMain:bool,
        name:string, 
        sex:string,
        age:int, 
        look:string,
        character:Text, 
        motivation:Text, 
        memory:Text):Person =
    result = Person(
        isMain: isMain,
        name: name, 
        sex: sex,
        age: age, 
        look: look,
        character: character, 
        motivation: motivation, 
        memory: memory)

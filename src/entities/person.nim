import ../ai_api/[types, ai_api]
import json
import options
import strformat
import random
import strutils

import ../common/prompt

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
    # Возраст персонажа
    age*: int
    # Характеристики персонажа
    character*: seq[string]
    # Мотивация персонажа: инстинкты, желания, цели
    motivation*: seq[string]
    # Память персонажа
    memory*: seq[string]


# Оператор для вывода персонажа
proc `$`*(person: Person): string =
    return person.name & " " & $person.age & " " & $person.character

# Создает нового персонажа
proc newPerson*(
        isMain:bool,
        name:string, 
        age:int, 
        character:seq[string], 
        motivation:seq[string], 
        memory:seq[string]):Person =
    result = Person(
        isMain: isMain,
        name: name, 
        age: age, 
        character: character, 
        motivation: motivation, 
        memory: memory)

# Получает prompt для персонажа
proc getPrompt*(pers: Person): Prompt =
    var prompt = newPrompt()
    prompt.addLine(fmt"{pers.name}. Возраст: {pers.age}")
    let character = pers.character.join(", ")
    prompt.addLine(fmt"Характер: {character}")
    let motivation = pers.motivation.join(", ")
    prompt.addLine(fmt"Мотивация: {motivation}")
    let memory = pers.memory.join(", ")
    prompt.addLine(fmt"Помнит: {memory}")
    return prompt

# Кидает инициативу персонажа
proc throwInitiative*(person: Person): int =
    return rand(100)

# Создает произвольного персонажа
proc createRandomPerson*() : Person =
    let ai = ai_api.get()
    let prompt = "Придумай произвольного персонажа: имя фамилию отчество, возраст, характер(список максимум из 5 слов), мотивация(список максимум из 5 слов), память(список максимум из 5 слов)"
    let completeResult = ai.complete(@["Ты рассказчик"], @[prompt], some(
        CompleteOptions(
            structuredResponse: some(
                %* {
                    "type": "json_schema",
                    "json_schema": {
                    "name": "person_response",
                    "strict": "true",
                    "schema": {
                    "type": "object",
                    "properties": {
                        "Name": {
                            "description": "Имя",
                            "type": "string"
                        },
                        "Age": {
                            "description": "Возраст",
                            "type": "integer"
                        },
                        "Character": {
                            "type": "array",
                            "description": "Характер",
                            "items": {
                                "type": "string"
                                }
                            }
                        },
                        "Motivation": {
                            "type": "array",
                            "description": "Мотивация",
                            "items": {
                                "type": "string"
                                }
                            }
                        },
                        "Memory": {
                            "type": "array",
                            "description": "Память",
                            "items": {
                                "type": "string"
                            }
                        },
                        "required": ["Name", "Age", "Character", "Motivation", "Memory"]
                    }
                }                        
        )
    )))

    let personJson = parseJson(completeResult)
    let person = to(personJson, Person)
    return person

import json
import options
import random
import strformat
import strutils

import ../../ai_api/openai_api
import ../../entities/person
import ../../common/prompt  
import types

# Получает prompt для персонажа
proc getPersonPrompt*(pers: Person): Prompt =
    var prompt = newPrompt()
    if pers.isMain:
        prompt.addLine(fmt"{pers.name} (главный персонаж)")
    else:
        prompt.addLine(fmt"{pers.name}")

    prompt.addLine(fmt"Возраст: {pers.age}")
    let character = pers.character.join(", ")
    prompt.addLine(fmt"Внешность: {pers.look}")
    prompt.addLine(fmt"Характер: {character}")
    let motivation = pers.motivation.join(", ")
    prompt.addLine(fmt"Хочет {motivation}")
    let memory = pers.memory.join(", ")
    prompt.addLine(fmt"Помнит что: {memory}")
    return prompt

# Кидает инициативу персонажу
proc throwInitiative*(person: Person): int =
    return rand(100)

# Создает произвольного персонажа
proc createRandomPerson*(ai: ApiWithModel) : Person =
    var prompt = newPrompt()
    prompt.addLine("Придумай произвольного персонажа: имя фамилию отчество, возраст, характер(список максимум из 5 слов), мотивация(список максимум из 5 слов), память(список максимум из 5 слов)")
    let completeResult = ai.api.complete(ai.model, @["Ты рассказчик"], prompt, some(
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
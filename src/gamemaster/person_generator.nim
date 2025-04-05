import json
import options
import random

import ../ai_api/[types, ai_api]
import ../entities/person
import ../common/prompt

# Кидает инициативу персонажу
proc throwInitiative*(person: Person): int =
    return rand(100)

# Создает произвольного персонажа
proc createRandomPerson*() : Person =
    let ai = ai_api.get()
    var prompt = newPrompt()
    prompt.addLine("Придумай произвольного персонажа: имя фамилию отчество, возраст, характер(список максимум из 5 слов), мотивация(список максимум из 5 слов), память(список максимум из 5 слов)")
    let completeResult = ai.complete(@["Ты рассказчик"], prompt, some(
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
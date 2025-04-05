import options
import types

import openai_api

# API для работы с ИИ
var ai:Option[IAiApi] = none(IAiApi)

# Получает API для работы с ИИ
proc get*():IAiApi =
    if ai.isSome:
        return ai.get()

    let ai = newOpenAiApi("http://localhost:1234")
    return ai
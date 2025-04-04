import json
import options

# Структура опций для запроса завершения
type CompleteOptions* = object
    # Опция для структурированного ответа
    structuredResponse*: Option[JsonNode]
    # Опция для температуры генерации
    temperature*: Option[float]
    # Опция для максимального количества токенов
    max_tokens*: Option[int]
    # Опция для стриминга ответа
    stream*: Option[bool]

# Интерфейс для работы с AI API
type IAiApi* = object
    # Получает завершенный текста
    complete*: proc(
        systemPrompt: seq[string], 
        userPrompt: seq[string],
        options: Option[CompleteOptions] = none(CompleteOptions)
    ): string


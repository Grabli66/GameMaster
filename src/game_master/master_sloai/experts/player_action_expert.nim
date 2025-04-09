import ../../../ai_api/openai_api

# Эксперт по действиям игрока
type PlayerActionExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по действиям игрока
proc newPlayerActionExpert*(apiCollection: ApiCollection): PlayerActionExpert =
    result = PlayerActionExpert()


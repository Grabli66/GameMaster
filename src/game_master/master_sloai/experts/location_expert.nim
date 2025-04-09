import ../../../ai_api/openai_api

# Эксперт по местоположению
type LocationExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по местоположению
proc newLocationExpert*(apiCollection: ApiCollection): LocationExpert =
    result = LocationExpert()


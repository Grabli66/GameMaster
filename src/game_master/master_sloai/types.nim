import ../../ai_api/openai_api

# Доступ к API с моделью
type ApiWithModel* = object
    # Модель
    model*: string
    # API
    api*: OpenAiApi

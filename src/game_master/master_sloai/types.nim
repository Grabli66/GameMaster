import options

import ../../common/prompt
import ../../ai_api/openai_api

# Модель Gemma 3.4b IT
const gemma34bIt* = "gemma-3-4b-it"

# Доступ к API с моделями
type ApiWithModels* = object
    # Установленные модели
    models*: seq[string]
    # API
    api*: OpenAiApi

# Получает список моделей
template getModels*(self: ApiWithModels): seq[string] =
    self.api.getModels()

# Завершает текст с помощью API
template complete*(
        self: ApiWithModels, 
        model: string, 
        systemPrompt: Prompt, 
        userPrompt: Prompt, 
        options: Option[CompleteOptions]): string =
    self.api.complete(model, systemPrompt, userPrompt, options)

# Проверяет наличие модели в списке моделей
proc hasModel*(self: ApiWithModels, model: string): bool =
    return model in self.models

import httpclient
import json
import types
import options
import strformat

import ../common/settings
import ../common/prompt

# Константы по умолчанию для OpenAI API
const
  # Константа для температуры генерации
  DEFAULT_TEMPERATURE* = 0.7
  # Константа для максимального количества токенов
  DEFAULT_MAX_TOKENS* = 150
  # Константа для стриминга ответа
  DEFAULT_STREAM* = false
  # Константа для успешного HTTP статуса
  HTTP_STATUS_OK* = "200 OK"

# Тип для работы с OpenAI API
type OpenAiApi = object
    # Модель для генерации текста
    model: string
    # HTTP клиент для отправки запросов
    client: HttpClient
    # Базовый URL API
    baseUrl: string

# Допустимые модели
let allowedModels = @[
    "aya-23-8b",
    "hermes-3-llama-3.1-8b",
    "ruadaptqwen2.5-14b-instruct-1m"
]

# Получает оптимальную модель для генерации текста
proc getOptimalModel(self: OpenAiApi): Option[string] =
    let response = self.client.get(fmt"{self.baseUrl}/v1/models")  
    if response.status != HTTP_STATUS_OK:
        raise newException(ValueError, fmt"API error: {response.body}")

    let jsonResponse = parseJson(response.body)
    let models = jsonResponse["data"].getElems()
    for model in models:
        if model["id"].getStr() in allowedModels:
            return some(model["id"].getStr())

    return none(string)

# Завершает текст с помощью OpenAI API
proc complete(
        self: OpenAiApi, 
        systemPrompt: Prompt, 
        userPrompt: Prompt,
        options: Option[CompleteOptions]): string =

    var messages: seq[JsonNode] = @[]
    
    if settings.isDebug:
        echo "Системный prompt:"
        systemPrompt.debug()
        echo "Пользовательский prompt:"
        userPrompt.debug()

    for prompt in systemPrompt:        
        messages.add(%* {"role": "system", "content": prompt})
    
    for prompt in userPrompt:
        messages.add(%* {"role": "user", "content": prompt})

    var requestBody = %* {
        "model": self.model,
        "messages": messages,
        "temperature": DEFAULT_TEMPERATURE,
        "max_tokens": DEFAULT_MAX_TOKENS,
        "stream": DEFAULT_STREAM
    }

    if options.isSome:
        let opts = options.get()
        
        if opts.temperature.isSome:
            requestBody["temperature"] = %opts.temperature.get()
            
        if opts.max_tokens.isSome:
            requestBody["max_tokens"] = %opts.max_tokens.get()
            
        if opts.stream.isSome:
            requestBody["stream"] = %opts.stream.get()
            
        if opts.structuredResponse.isSome:
            requestBody["response_format"] = opts.structuredResponse.get()

    if settings.isDebug:
        echo fmt"запрос: {requestBody}"

    let response = self.client.post(self.baseUrl & "/v1/chat/completions", $requestBody)    
        
    if response.status != HTTP_STATUS_OK:
        raise newException(ValueError, fmt"API error: {response.body}")

    if settings.isDebug:
        echo fmt"ответ: {response.body}"

    let jsonResponse = parseJson(response.body)
    result = jsonResponse["choices"][0]["message"]["content"].getStr()

# Создает новый API для работы с ИИ в формате с OpenAI
proc newOpenAiApi*(baseUrl: string, model: string): IAiApi =    
    var api = OpenAiApi(        
        client: newHttpClient(),
        baseUrl: baseUrl
    )

    let model = getOptimalModel(api)
    if model.isNone:
        raise newException(ValueError, "Не удалось получить оптимальную модель")

    api.model = model.get()

    api.client.headers = newHttpHeaders({
        "Content-Type": "application/json"
    })
    return IAiApi(
        complete: proc(
                systemPrompt: seq[string], 
                userPrompt: seq[string], 
                options: Option[CompleteOptions] = none(CompleteOptions)): string =
            return complete(api, systemPrompt, userPrompt, options)
    )
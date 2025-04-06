import httpclient
import json
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

# Тип для работы с OpenAI API
type OpenAiApi* = object
    # Базовый URL API
    baseUrl: string

# Получает HTTP клиент
proc getClient(): HttpClient =
    result = newHttpClient()
    result.headers = newHttpHeaders({
        "Content-Type": "application/json"
    })

# Получает ответ от OpenAI API
proc getCompletions(self: OpenAiApi, requestBody:string): string =
    let client = getClient()
    let response = client.post(self.baseUrl & "/v1/chat/completions", requestBody)
    if response.status != HTTP_STATUS_OK:
        raise newException(ValueError, fmt"API error: {response.body}")

    if settings.isDebug:
        echo fmt"ответ: {response.body}"

    let jsonResponse = parseJson(response.body)
    return jsonResponse["choices"][0]["message"]["content"].getStr()

# Получает список моделей
proc getModels*(self: OpenAiApi): seq[string] =
    let client = getClient()
    let response = client.get(fmt"{self.baseUrl}/v1/models")  
    if response.status != HTTP_STATUS_OK:
        raise newException(ValueError, fmt"API error: {response.body}")

    let jsonResponse = parseJson(response.body)
    let models = jsonResponse["data"].getElems()
    for model in models:
        result.add(model["id"].getStr())

# Завершает текст с помощью OpenAI API
proc complete*(
        self: OpenAiApi, 
        model: string,
        systemPrompt: Prompt, 
        userPrompt: Prompt,
        options: Option[CompleteOptions]): string =

    var messages: seq[JsonNode] = @[]
    
    if settings.isDebug:
        echo "Системный prompt:"
        systemPrompt.debug()
        echo "Пользовательский prompt:"
        userPrompt.debug()
    
    if systemPrompt.len > 0:
        for prompt in systemPrompt:
            messages.add(%* {"role": "system", "content": prompt})
    
    if userPrompt.len > 0:        
        for prompt in userPrompt:
            messages.add(%* {"role": "user", "content": prompt})

    var requestBody = %* {
        "model": model,
        "messages": messages,
        "temperature": DEFAULT_TEMPERATURE,
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
    
    return self.getCompletions($requestBody)

# Создает новый API для работы с ИИ в формате с OpenAI
proc newOpenAiApi*(baseUrl: string): OpenAiApi =    
    var api = OpenAiApi(
        baseUrl: baseUrl,
    )

    return api
import options

import types
import ../../ai_api/openai_api
import ../../entities/location
import ../../common/prompt

# Создает описание местоположения
proc createLocationDescription*(ai: ApiWithModel, location: Location, maxTokens: int) : string =    
    var systemPrompt: Prompt = newPrompt()
    systemPrompt.addLine("Do not use markdown, only plain text")
    var userPrompt = location.getPrompt()
    userPrompt.addLine("Опиши как выглядит локация изнутри и снаружи.")
    let completeResult = ai.api.complete(ai.model, systemPrompt, userPrompt, some(CompleteOptions(
        maxTokens: some(maxTokens),
        temperature: some(0.0),
        stream: some(false)
    )))
    return completeResult
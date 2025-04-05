import options

import ../ai_api/[types, ai_api]
import ../entities/location
import ../common/prompt

# Создает описание местоположения
proc createLocationDescription*(location: Location, maxTokens: int) : string =
    let ai = ai_api.get()
    var systemPrompt: Prompt = newPrompt()
    systemPrompt.addLine("Do not use markdown, only plain text")
    var userPrompt = location.getPrompt()
    userPrompt.addLine("Опиши как выглядит локация изнутри и снаружи.")
    let completeResult = ai.complete(systemPrompt, userPrompt, some(CompleteOptions(
        maxTokens: some(maxTokens),
        temperature: some(0.08),
        stream: some(false)
    )))
    return completeResult
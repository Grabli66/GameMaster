import strformat

# Тип для prompt
type Prompt* = seq[string]

# Создает новый prompt
proc newPrompt*(): Prompt =
    return @[]

# Добавляет строку в prompt с переносом строки
proc addLine*(prompt: var Prompt, line: string) =
    prompt.add(fmt"{line}\n")

# Выводит prompt в консоль
proc debug*(prompt: Prompt) =
    for line in prompt:
        echo line

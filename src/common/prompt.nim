import strutils

# Тип для prompt
type Prompt* = seq[string]

# Создает новый prompt
proc newPrompt*(): Prompt =
    return @[]

# Преобразует prompt в строку
proc toString*(prompt: Prompt): string =
    return prompt.join("\n")

# Добавляет строку в prompt с переносом строки
proc addLine*(prompt: var Prompt, line: string) =
    prompt.add(line)

# Выводит prompt в консоль
proc debug*(prompt: Prompt) =
    for line in prompt:
        echo line

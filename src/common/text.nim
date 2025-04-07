import strutils

# Тип для prompt
type Text* = seq[string]

# Создает новый prompt
proc newText*(): Text =
    return @[]

# Преобразует текст в строку
proc toString*(text: Text): string =
    return text.join("\n")

# Добавляет строку в prompt с переносом строки
proc addLine*(text: var Text, line: string) =
    text.add(line)

# Выводит текст в консоль
proc debug*(text: Text) =
    for line in text:
        echo line

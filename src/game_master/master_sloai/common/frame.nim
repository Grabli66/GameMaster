import ../../../entities/person

# Кадр
type Frame* = object
    # Персонажи в кадре с их действиями
    personsWithActions*: seq[PersonWithActions]

# Создает новый кадр
proc newFrame*(): Frame =
    result = Frame(personsWithActions: @[])

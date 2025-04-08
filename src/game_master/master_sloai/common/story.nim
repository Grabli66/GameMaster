import ../../../common/text

# Состояние истории
type  
    StoryState* = enum
        # Инициализация
        ssInit
        # Ввод игроком данных
        ssInput
        # Рассказ истории
        ssStory
        # Истории закончились
        ssEnd

    # История которую рассказывает мастер
    Story* = object
        # Текст истории
        text*: seq[Text]
        # Последний текст истории
        lastText*: Text
        # Состояние истории
        state*: StoryState
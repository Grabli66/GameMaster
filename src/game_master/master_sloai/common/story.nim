import ../../../common/text
import ../../../entities/scene

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
        # Состояние истории
        state*: StoryState    
        # Текущая сцена
        currentScene*: Scene
        # Текст истории
        text*: seq[Text]
        # Последний текст истории
        lastText*: Text          

# Создает новую историю
proc newStory*(scene: Scene): Story =
    result = Story(
        state: ssInit,
        currentScene: scene,
        text: @[],
        lastText: newText()
    )

# Эксперт по рассказыванию историй

import ../../../entities/game_book
import ../../../common/text
import ../common/story

# Эксперт по рассказыванию историй
type StoryTellerExpert* = object

# Создает пролог для истории
proc createPrologue*(expert: StoryTellerExpert, gameBook: GameBook, story: Story): Text =
    return newText("Жопосраный пролог")


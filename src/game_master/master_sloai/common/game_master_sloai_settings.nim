import std/options

import ../../../entities/game_book
import ../../../ai_api/openai_api
import ../experts/[storyteller_expert, quest_designer_expert, person_expert, player_action_expert, location_expert]

# Настройки мастера игры
type GameMasterSloaiSettings* = object
    # Источники API
    apiCollection*: ApiCollection
    # Книга с историей и правилами игры
    gameBook*: GameBook
    # Эксперт по рассказыванию историй
    storyTellerExpert*: Option[StoryTellerExpert]
    # Эксперт по мотивации персонажа
    personMotivationExpert*: Option[PersonExpert]
    # Эксперт по действиям игрока
    playerActionExpert*: Option[PlayerActionExpert]
    # Эксперт по местоположению
    locationExpert*: Option[LocationExpert] 
    # Эксперт по созданию квестов
    questDesignerExpert*: Option[QuestDesignerExpert]

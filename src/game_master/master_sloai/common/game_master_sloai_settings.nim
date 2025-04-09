import std/options

import ../../../entities/game_book
import ../../../ai_api/openai_api
import ../../../entities/scene
import ../experts/[storyteller_expert, quest_designer_expert, psychologist_expert, player_action_expert, location_expert]

# Настройки мастера игры
type GameMasterSloaiSettings* = object
    # Источники API
    apiCollection*: ApiCollection
    # Книга с историей и правилами игры
    gameBook*: GameBook
    # Начальная сцена
    startScene*: Scene
    # Эксперт по рассказыванию историй
    storyTellerExpert*: Option[StoryTellerExpert]
    # Эксперт по психологии людей, их мотивациям и поведению
    psychologistExpert*: Option[PsychologistExpert]
    # Эксперт по действиям игрока
    playerActionExpert*: Option[PlayerActionExpert]
    # Эксперт по местоположению
    locationExpert*: Option[LocationExpert] 
    # Эксперт по созданию квестов
    questDesignerExpert*: Option[QuestDesignerExpert]

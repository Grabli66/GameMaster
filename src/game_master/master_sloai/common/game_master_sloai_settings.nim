import std/options

import ../../../entities/game_book
import ../../../ai_api/openai_api
import ../experts/storyteller_expert
import ../experts/person_expert
import ../experts/player_action_expert
import ../experts/location_expert

# Настройки мастера игры
type GameMasterSloaiSettings* = object
    # API с моделями
    apis*: seq[ApiWithModels]
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
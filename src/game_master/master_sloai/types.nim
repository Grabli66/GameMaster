import options

import ../../ai_api/openai_api
import ../../entities/game_book
import ../../common/text
import ./experts/story_teller_expert
import ./experts/person_expert
import ./experts/player_action_expert
import ./experts/location_expert

type
  # Тип эксперта
  ExpertType* = enum
    # Эксперт по рассказыванию историй
    etStoryTeller
    # Эксперт по мотивации персонажа
    etPersonMotivation
    # Эксперт по действиям игрока
    etPlayerAction
    # Эксперт по местоположению
    etLocation

    # Состояние истории
  StoryState* = enum
    # Инициализация
    ssInit
    # Ввод игроком данных
    ssInput
    # Рассказ истории
    ssStory
    # Истории закончились
    ssEnd

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

# История которую рассказывает мастер
type Story* = object
  # Текст истории
  text*: seq[Text]
  # Последний текст истории
  lastText*: Text
  # Состояние истории
  state*: StoryState

# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import std/options

import ../../ai_api/openai_api
import ../../entities/game_book
import ./experts/story_teller_expert
import ./experts/person_expert
import ./experts/player_action_expert
import ./experts/location_expert
import ./types

# Мастер игры
type GameMasterSloai* = object
    # API с моделями
    apis*: seq[ApiWithModels]
    # Книга с историей и правилами игры
    noteBook*: GameBook
    # Эксперт по рассказыванию историй
    storyTellerExpert*: StoryTellerExpert
    # Эксперт по мотивации персонажа
    personMotivationExpert*: PersonExpert
    # Эксперт по действиям игрока
    playerActionExpert*: PlayerActionExpert
    # Эксперт по местоположению
    locationExpert*: LocationExpert 

# Создает новый экземпляр мастера игры
proc newGameMasterSloai*(settings: GameMasterSloaiSettings): GameMasterSloai =
    result = GameMasterSloai(
        apis: settings.apis,
        noteBook: settings.gameBook,
        storyTellerExpert: if settings.storyTellerExpert.isSome: settings.storyTellerExpert.get else: StoryTellerExpert(),
        personMotivationExpert: if settings.personMotivationExpert.isSome: settings.personMotivationExpert.get else: PersonExpert(),
        playerActionExpert: if settings.playerActionExpert.isSome: settings.playerActionExpert.get else: PlayerActionExpert(),
        locationExpert: if settings.locationExpert.isSome: settings.locationExpert.get else: LocationExpert()
    )

# Начинает игру, создает эпилог и описывает начальную сцену
proc startGame*(gm: GameMasterSloai): Story =
    return Story()

# Итерирует сцену и возвращает историю с обновленным текстом
proc iterateScene*(gm: GameMasterSloai, story: Story): Story =
    return Story()
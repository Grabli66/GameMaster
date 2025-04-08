# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import std/options

import ../../ai_api/openai_api
import ../../entities/game_book
import ../../common/text
import ./experts/storyteller_expert
import ./experts/person_expert
import ./experts/player_action_expert
import ./experts/location_expert
import ./common/[story, game_master_sloai_settings]

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
    # История которую рассказывает мастер
    story*: Story

# Создает новый экземпляр мастера игры
proc newGameMasterSloai*(settings: GameMasterSloaiSettings): GameMasterSloai =
    let storyTellerExpert = if settings.storyTellerExpert.isSome: settings.storyTellerExpert.get else: StoryTellerExpert()
    let personMotivationExpert = if settings.personMotivationExpert.isSome: settings.personMotivationExpert.get else: PersonExpert()
    let playerActionExpert = if settings.playerActionExpert.isSome: settings.playerActionExpert.get else: PlayerActionExpert()
    let locationExpert = if settings.locationExpert.isSome: settings.locationExpert.get else: LocationExpert()

    result = GameMasterSloai(
        apis: settings.apis,
        noteBook: settings.gameBook,
        storyTellerExpert: storyTellerExpert,
        personMotivationExpert: personMotivationExpert,
        playerActionExpert: playerActionExpert,
        locationExpert: locationExpert,
        story: Story(
            text: @[],
            lastText: newText(),
            state: ssInit
        )
    )

# Начинает игру, создает пролог и описывает начальную сцену
proc startGame*(gm: var GameMasterSloai): Story =   
    # Рассказчик историй создает пролог
    let prologue = gm.storyTellerExpert.createPrologue(gm.noteBook, gm.story)
    gm.story.text.add(prologue)
    gm.story.lastText = prologue
    return gm.story

# Итерирует сцену и возвращает историю с обновленным текстом
proc iterateScene*(gm: GameMasterSloai, story: Story): Story =
    # Обрабатывает ввод игроком данных
    if story.state == ssInput:
        return gm.story
    # Рассказывает историю
    else:
        return gm.story
# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import std/options

import ../../ai_api/openai_api
import ../../entities/game_book
import ../../common/text
import ./experts/storyteller_expert
import ./experts/psychologist_expert
import ./experts/player_action_expert
import ./experts/location_expert
import ./common/[story, game_master_sloai_settings]

# Мастер игры
type GameMasterSloai* = object
    # Источники API
    apiCollection*: ApiCollection
    # Книга с историей и правилами игры
    noteBook*: GameBook
    # Эксперт по рассказыванию историй
    storyTellerExpert*: StoryTellerExpert
    # Эксперт по психологии людей, их мотивациям и поведению
    psychologistExpert*: PsychologistExpert
    # Эксперт по действиям игрока
    playerActionExpert*: PlayerActionExpert
    # Эксперт по местоположению
    locationExpert*: LocationExpert 
    # История которую рассказывает мастер
    story*: Story

# Создает новый экземпляр мастера игры
proc newGameMasterSloai*(settings: GameMasterSloaiSettings): GameMasterSloai =
    let storyTellerExpert = if settings.storyTellerExpert.isSome: settings.storyTellerExpert.get else: newStoryTellerExpert(settings.apiCollection)
    let psychologistExpert = if settings.psychologistExpert.isSome: settings.psychologistExpert.get else: newPsychologistExpert(settings.apiCollection)
    let playerActionExpert = if settings.playerActionExpert.isSome: settings.playerActionExpert.get else: newPlayerActionExpert(settings.apiCollection)
    let locationExpert = if settings.locationExpert.isSome: settings.locationExpert.get else: newLocationExpert(settings.apiCollection)

    result = GameMasterSloai(
        apiCollection: settings.apiCollection,
        noteBook: settings.gameBook,
        storyTellerExpert: storyTellerExpert,
        psychologistExpert: psychologistExpert,
        playerActionExpert: playerActionExpert,
        locationExpert: locationExpert,
        story: newStory(settings.startScene)
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
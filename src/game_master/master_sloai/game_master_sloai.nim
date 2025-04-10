# Модуль для мастера игры основанного на локальных небольших моделях LLM (Small Local OpenAI API)

import std/options
import std/algorithm

import ../../ai_api/openai_api
import ../../entities/[game_book, person]
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
proc startGame*(gm: var GameMasterSloai) =   
    # Рассказчик историй создает пролог
    let prologue = gm.storyTellerExpert.createPrologue(gm.noteBook, gm.story)
    gm.story.text.add(prologue)
    gm.story.lastText = prologue

# Итерирует сцену и возвращает историю с обновленным текстом
proc iterateScene*(gm: var GameMasterSloai) =    
    # Обрабатывает ввод игроком данных
    if gm.story.state == ssInput:
        return
    # Рассказывает историю
    else:
        # Кидает иннициативу для всех персонажей
        type PersonWithInitiative = object
            initiative: int
            person: Person

        var personsWithInitiative = newSeq[PersonWithInitiative]()
        for character in gm.story.currentScene.currentPersons:
            let initiative = gm.psychologistExpert.getInitiative(character)
            personsWithInitiative.add(PersonWithInitiative(initiative: initiative, person: character))

        # Сортирует персонажей по инициативе чтобы определить кто из них ходит
        personsWithInitiative.sort(proc(a, b: PersonWithInitiative): int = b.initiative - a.initiative)

        # Проходит по всем персонажам, если персонаж главный то возвращает историю с состоянием ssInput
        for personWithInitiative in personsWithInitiative:
            if personWithInitiative.person.isMain:
                gm.story.state = ssInput
                return
            else:
                # Вызывает психолога, психолог анализирует что делает персонаж и возвращает действия персонажа
                let actions = gm.psychologistExpert.getPersonActions(personWithInitiative.person)
                gm.story.currentFrame.personsWithActions.add(newPersonWithActions(personWithInitiative.person, actions))

        # Записывает в историю действия персонажа
        # Передает действия персонажей рассказчику историй
        # Рассказчик сочиняет текст истории
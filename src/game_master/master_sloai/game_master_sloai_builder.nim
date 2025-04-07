import options

import ../../ai_api/openai_api
import ../../entities/game_book
import ./experts/story_teller_expert
import ./experts/person_expert
import ./experts/player_action_expert
import ./experts/location_expert
import ./game_master_sloai
import ./types

# Билдер для мастера игры
type GameMasterSloaiBuilder* = object
    settings: GameMasterSloaiSettings

# Создает новый экземпляр билдера
proc newGameMasterSloaiBuilder*(dataSource: seq[ApiWithModels], book: GameBook): GameMasterSloaiBuilder =  
  result = GameMasterSloaiBuilder(
    settings: GameMasterSloaiSettings(
        apis: dataSource,
        storyTellerExpert: none(StoryTellerExpert),
        personMotivationExpert: none(PersonExpert),
        playerActionExpert: none(PlayerActionExpert),
        locationExpert: none(LocationExpert),
        gameBook: book
    )
  )

# Добавляет эксперта по рассказыванию историй
proc setStoryTellerExpert*(builder: var GameMasterSloaiBuilder, expert: StoryTellerExpert) =
  builder.settings.storyTellerExpert = some(expert)

# Добавляет эксперта по мотивации персонажа
proc setPersonMotivationExpert*(builder: var GameMasterSloaiBuilder, expert: PersonExpert) =
  builder.settings.personMotivationExpert = some(expert)

# Добавляет эксперта по действиям игрока
proc setPlayerActionExpert*(builder: var GameMasterSloaiBuilder, expert: PlayerActionExpert) =
  builder.settings.playerActionExpert = some(expert)

# Добавляет эксперта по местоположению
proc setLocationExpert*(builder: var GameMasterSloaiBuilder, expert: LocationExpert) =
  builder.settings.locationExpert = some(expert)

# Создает и возвращает экземпляр GameMasterSloai
proc build*(builder: GameMasterSloaiBuilder): GameMasterSloai =
  result = newGameMasterSloai(builder.settings) 
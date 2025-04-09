import options

import ../../ai_api/openai_api
import ../../entities/game_book
import ../../entities/scene
import ./experts/[storyteller_expert, quest_designer_expert, psychologist_expert, player_action_expert, location_expert]
import ./game_master_sloai
import ./common/game_master_sloai_settings

# Билдер для мастера игры
type GameMasterSloaiBuilder* = object
    settings: GameMasterSloaiSettings

# Создает новый экземпляр билдера
proc newGameMasterSloaiBuilder*(apiCollection: ApiCollection, book: GameBook, startScene: Scene): GameMasterSloaiBuilder =  
  result = GameMasterSloaiBuilder(
    settings: GameMasterSloaiSettings(
        apiCollection: apiCollection,
        storyTellerExpert: none(StoryTellerExpert),
        psychologistExpert: none(PsychologistExpert),
        playerActionExpert: none(PlayerActionExpert),
        locationExpert: none(LocationExpert),
        questDesignerExpert: none(QuestDesignerExpert),
        gameBook: book,
        startScene: startScene
    )
  )

# Добавляет эксперта по рассказыванию историй
proc setStoryTellerExpert*(builder: var GameMasterSloaiBuilder, expert: StoryTellerExpert) =
  builder.settings.storyTellerExpert = some(expert)

# Добавляет эксперта по психологии людей, их мотивациям и поведению
proc setPsychologistExpert*(builder: var GameMasterSloaiBuilder, expert: PsychologistExpert) =
  builder.settings.psychologistExpert = some(expert)

# Добавляет эксперта по действиям игрока
proc setPlayerActionExpert*(builder: var GameMasterSloaiBuilder, expert: PlayerActionExpert) =
  builder.settings.playerActionExpert = some(expert)

# Добавляет эксперта по местоположению
proc setLocationExpert*(builder: var GameMasterSloaiBuilder, expert: LocationExpert) =
  builder.settings.locationExpert = some(expert)

# Добавляет эксперта по созданию квестов
proc setQuestDesignerExpert*(builder: var GameMasterSloaiBuilder, expert: QuestDesignerExpert) =
  builder.settings.questDesignerExpert = some(expert)

# Создает и возвращает экземпляр GameMasterSloai
proc build*(builder: GameMasterSloaiBuilder): GameMasterSloai =
  result = newGameMasterSloai(builder.settings) 
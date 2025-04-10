import random

import ../../../ai_api/openai_api
import ../../../entities/person

# Эксперт по психологии людей, их мотивациям и поведению
type PsychologistExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по психологии людей, их мотивациям и поведению
proc newPsychologistExpert*(apiCollection: ApiCollection): PsychologistExpert =
    result = PsychologistExpert()

# Получает инициативу персонажа
proc getInitiative*(psychologist: PsychologistExpert, character: Person): int =
    if character.isMain:
        result = random.rand(1..100)
    else:
        result = random.rand(1..100)

# Получает действия персонажа
proc getPersonActions*(psychologist: PsychologistExpert, character: Person): seq[PersonAction] =
    result = @[]


import ../../../ai_api/openai_api

# Эксперт по психологии людей, их мотивациям и поведению
type PsychologistExpert* = object
    # API
    api*: OpenAiApi
    # Модель для генерации текста
    model*: string

# Создает новый эксперт по психологии людей, их мотивациям и поведению
proc newPsychologistExpert*(apiCollection: ApiCollection): PsychologistExpert =
    result = PsychologistExpert()



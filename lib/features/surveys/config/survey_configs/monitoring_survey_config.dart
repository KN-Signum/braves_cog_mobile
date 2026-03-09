import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class MonitoringSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'monitoring',
      title: 'Monitoring',
      questions: [
        // Q1: Jak się dzisiaj czujesz? (1-10 segment scale)
        SurveyQuestionEntity(
          id: 'q1',
          type: QuestionType.slider,
          question: 'Jak się dzisiaj czujesz?',
          required: true,
          options: {
            'min': 1,
            'max': 10,
            'segmentScale': true,
            // Odwrócona skala: 1 (lewa) = bardzo źle (czerwone), 10 (prawa) = bardzo dobrze (zielone)
            'reversed': true,
            'minLabel': 'Bardzo źle',
            'maxLabel': 'Bardzo dobrze',
          },
        ),
        // Q2: Problemy z pamięcią (conditional - only if q1 < 6, i.e., q1 <= 5)
        SurveyQuestionEntity(
          id: 'q2_memory',
          type: QuestionType.slider,
          question: 'Czy masz problemy z pamięcią, koncentracją lub kojarzeniem?',
          required: true,
          options: {
            'min': 1,
            'max': 10,
            'segmentScale': true,
            'reversed': true, // Red for 1 (very severe), green for 10 (none)
            'minLabel': 'Bardzo nasilone',
            'maxLabel': 'Brak',
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'q1',
              'operator': '<',
              'value': 6,
            },
          },
        ),
        // Q3: Co konkretnie powoduje (conditional - only if q1 < 6)
        SurveyQuestionEntity(
          id: 'q3_reason',
          type: QuestionType.text,
          question: 'Czy jest coś konkretnego, co powoduje, że źle się czujesz?',
          required: false,
          options: {
            'multiline': true,
            'placeholder': 'Opisz...',
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'q1',
              'operator': '<',
              'value': 6,
            },
          },
        ),
        // Q4: Wizyta u lekarza (composite)
        SurveyQuestionEntity(
          id: 'q4_doctor',
          type: QuestionType.boolean,
          question: 'Czy byłeś w ostatnim czasie u lekarza?',
          required: true,
          genderForm: 'byłeś',
          options: {
            'composite': 'doctor_visit',
          },
        ),
        // Q5: Zmiana leków (composite)
        SurveyQuestionEntity(
          id: 'q5_meds_changed',
          type: QuestionType.boolean,
          question: 'Czy w ostatnim czasie zmieniłeś dawkowanie lub zacząłeś przyjmować nowe leki?',
          required: true,
          genderForm: 'zmieniłeś',
          options: {
            'composite': 'medications',
          },
        ),
      ],
    );
  }
}


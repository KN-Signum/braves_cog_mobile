import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class DemographicSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Demographic',
      title: 'Dane demograficzne',
      questions: [
        SurveyQuestionEntity(
          id: 'birth_year',
          type: QuestionType.text,
          question: 'Twój rok urodzenia',
          required: true,
          options: {
            'picker': 'year',
            'minYear': 1925,
            'maxYear': DateTime.now().year,
            'defaultYear': 1990,
          },
        ),
        SurveyQuestionEntity(
          id: 'height',
          type: QuestionType.text,
          question: 'Twój wzrost',
          required: true,
          options: {
            'picker': 'height',
          },
        ),
        SurveyQuestionEntity(
          id: 'weight',
          type: QuestionType.text,
          question: 'Twoja waga',
          required: true,
          options: {
            'picker': 'weight',
          },
        ),
        SurveyQuestionEntity(
          id: 'biological_sex',
          type: QuestionType.text,
          question: 'Płeć biologiczna',
          required: true,
          options: {
            'picker': 'icon_grid',
            'columns': 2,
            'iconOptions': [
              {'value': 'male', 'label': 'Mężczyzna', 'icon': 'male'},
              {'value': 'female', 'label': 'Kobieta', 'icon': 'female'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'gender_identity',
          type: QuestionType.text,
          question: 'Tożsamość płciowa',
          required: true,
          options: {
            'picker': 'icon_grid',
            'columns': 2,
            'iconOptions': [
              {'value': 'male', 'label': 'Mężczyzna', 'icon': 'male'},
              {'value': 'female', 'label': 'Kobieta', 'icon': 'female'},
              {'value': 'non_binary', 'label': 'Niebinarna', 'icon': 'transgender'},
              {'value': 'other', 'label': 'Inna', 'icon': 'person_outline'},
              {'value': 'prefer_not_to_say', 'label': 'Wolę nie mówić', 'icon': 'block'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'gender_identity_other',
          type: QuestionType.text,
          question: 'Jeśli wybrano "Inna", opisz swoją tożsamość płciową:',
          required: true,
          options: {
            'placeholder': 'Wpisz tożsamość płciową',
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'gender_identity',
              'operator': '==',
              'value': 'other',
            },
          },
        ),
        SurveyQuestionEntity(
          id: 'disability',
          type: QuestionType.text,
          question: 'Niepełnosprawność',
          required: true,
          options: {
            'picker': 'icon_grid',
            'columns': 2,
            'iconOptions': [
              {'value': 'none', 'label': 'Brak', 'icon': 'accessibility_new'},
              {'value': 'mild', 'label': 'Lekka', 'icon': 'accessible'},
              {'value': 'moderate', 'label': 'Umiarkowana', 'icon': 'accessible_forward'},
              {'value': 'severe', 'label': 'Znaczna', 'icon': 'wheelchair_pickup'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'education',
          type: QuestionType.text,
          question: 'Wykształcenie',
          required: true,
          options: {
            'picker': 'icon_grid',
            'columns': 2,
            'iconOptions': [
              {'value': 'primary', 'label': 'Podstawowe', 'icon': 'school_outlined'},
              {'value': 'vocational', 'label': 'Zawodowe', 'icon': 'build_outlined'},
              {'value': 'secondary', 'label': 'Średnie', 'icon': 'menu_book'},
              {'value': 'higher', 'label': 'Wyższe', 'icon': 'school'},
              {'value': 'other', 'label': 'Inne', 'icon': 'more_horiz'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'education_other',
          type: QuestionType.text,
          question: 'Jeśli wybrano "Inne", opisz swoje wykształcenie:',
          required: true,
          options: {
            'placeholder': 'Wpisz wykształcenie',
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'education',
              'operator': '==',
              'value': 'other',
            },
          },
        ),
      ],
    );
  }
}


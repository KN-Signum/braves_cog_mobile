import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class IPAQSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Physical_Activity',
      title: 'Aktywność fizyczna (IPAQ)',
      questions: [
        SurveyQuestionEntity(
          id: 'ipaq_info',
          type: QuestionType.text,
          question: 'Aktywność fizyczna',
          description:
              'W tej części prosimy o informacje dotyczące Twojej aktywności fizycznej w ciągu ostatnich 7 dni — w pracy, w domu i w czasie wolnym.\n\n'
              'Pytania dotyczą intensywnych i umiarkowanych ćwiczeń, a także codziennego chodzenia i czasu spędzanego w pozycji siedzącej.\n\n'
              'Szacowany czas: ok. 3–5 minut.',
          required: false,
          options: {'info': true, 'intro': true},
        ),
        SurveyQuestionEntity(
          id: 'ipaq_vigorous_days',
          type: QuestionType.choice,
          question:
              'W ciągu ostatnich 7 dni, przez ile dni wykonywałeś intensywne aktywności fizyczne, takie jak podnoszenie ciężarów, kopanie ziemi, aerobik lub szybka jazda na rowerze?',
          description:
              'Intensywne aktywności fizyczne to takie, które wymagają dużego wysiłku i powodują znacznie szybszy oddech niż normalnie. Uwzględnij tylko te aktywności, które trwały co najmniej 10 minut jednorazowo.',
          required: true,
          genderForm: 'wykonywałeś',
          options: {
            'options': [
              {'value': 0, 'label': '0 dni'},
              {'value': 1, 'label': '1 dzień'},
              {'value': 2, 'label': '2 dni'},
              {'value': 3, 'label': '3 dni'},
              {'value': 4, 'label': '4 dni'},
              {'value': 5, 'label': '5 dni'},
              {'value': 6, 'label': '6 dni'},
              {'value': 7, 'label': '7 dni'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_vigorous_time',
          type: QuestionType.number,
          question:
              'Ile czasu zazwyczaj poświęcałeś na intensywną aktywność fizyczną w jeden z tych dni?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 15,
            'maxMinutes': 59,
            'showDontKnow': true,
            'minMinutesIfZeroHours': 10,
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'ipaq_vigorous_days',
              'operator': '>',
              'value': 0,
            },
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_moderate_days',
          type: QuestionType.choice,
          question:
              'W ciągu ostatnich 7 dni, przez ile dni wykonywałeś umiarkowane aktywności fizyczne, takie jak noszenie lekkich przedmiotów, jazda na rowerze w stałym tempie lub tenis deblowy? Nie wliczaj chodzenia.',
          required: true,
          genderForm: 'wykonywałeś',
          options: {
            'options': [
              {'value': 0, 'label': '0 dni'},
              {'value': 1, 'label': '1 dzień'},
              {'value': 2, 'label': '2 dni'},
              {'value': 3, 'label': '3 dni'},
              {'value': 4, 'label': '4 dni'},
              {'value': 5, 'label': '5 dni'},
              {'value': 6, 'label': '6 dni'},
              {'value': 7, 'label': '7 dni'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_moderate_time',
          type: QuestionType.number,
          question:
              'Ile czasu zazwyczaj poświęcałeś na umiarkowaną aktywność fizyczną w jeden z tych dni?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 15,
            'maxMinutes': 59,
            'showDontKnow': true,
            'minMinutesIfZeroHours': 10,
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'ipaq_moderate_days',
              'operator': '>',
              'value': 0,
            },
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_walking_days',
          type: QuestionType.choice,
          question:
              'W ciągu ostatnich 7 dni, przez ile dni chodziłeś co najmniej 10 minut jednorazowo?',
          required: true,
          genderForm: 'chodziłeś',
          options: {
            'options': [
              {'value': 0, 'label': '0 dni'},
              {'value': 1, 'label': '1 dzień'},
              {'value': 2, 'label': '2 dni'},
              {'value': 3, 'label': '3 dni'},
              {'value': 4, 'label': '4 dni'},
              {'value': 5, 'label': '5 dni'},
              {'value': 6, 'label': '6 dni'},
              {'value': 7, 'label': '7 dni'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_walking_time',
          type: QuestionType.number,
          question:
              'Ile czasu zazwyczaj poświęcałeś na chodzenie w jeden z tych dni?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 15,
            'maxMinutes': 59,
            'showDontKnow': true,
            'minMinutesIfZeroHours': 10,
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'ipaq_walking_days',
              'operator': '>',
              'value': 0,
            },
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_sitting_time',
          type: QuestionType.number,
          question:
              'W ciągu ostatnich 7 dni, ile czasu spędzałeś siedząc w dzień roboczy?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 15,
            'maxMinutes': 59,
            'showDontKnow': true,
            'minMinutesIfZeroHours': 10,
          },
        ),
      ],
    );
  }
}

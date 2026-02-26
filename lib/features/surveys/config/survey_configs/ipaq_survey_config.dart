import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class IPAQSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Physical_Activity',
      title: 'Aktywność fizyczna (IPAQ)',
      questions: [
        SurveyQuestionEntity(
          id: 'iapq_info',
          type: QuestionType.text,
          question: 'Następne pytania będą dotyczyć czasu, jaki poświęciłeś/-aś na aktywność fizyczną w ciągu ostatnich 7 dni. Prosimy o odpowiedź na każde pytanie, nawet jeśli nie uważasz się za osobę aktywną. Pomyśl o aktywnościach wykonywanych w pracy, w domu i ogrodzie, podczas przemieszczania się z miejsca na miejsce oraz w czasie wolnym — rekreacyjnie, ćwicząc lub uprawiając sport.',
          required: false,
          options: {
            'info': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_vigorous_days',
          type: QuestionType.slider,
          question: 'W ciągu ostatnich 7 dni, przez ile dni wykonywałeś/-aś intensywne aktywności fizyczne, takie jak podnoszenie ciężarów, kopanie, aerobik lub szybka jazda na rowerze?',
          description: 'Intensywne aktywności fizyczne to takie, które wymagają dużego wysiłku i powodują znacznie szybszy oddech niż normalnie. Uwzględnij tylko te aktywności, które trwały co najmniej 10 minut jednorazowo.',
          required: true,
          genderForm: 'wykonywałeś',
          options: {
            'min': 0,
            'max': 7,
            'step': 1,
            'showMarkers': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_vigorous_time',
          type: QuestionType.number,
          question: 'Ile czasu zazwyczaj poświęcałeś/-aś na intensywną aktywność fizyczną w jeden z tych dni?',
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
          type: QuestionType.slider,
          question: 'W ciągu ostatnich 7 dni, przez ile dni wykonywałeś/-aś umiarkowane aktywności fizyczne, takie jak noszenie lekkich przedmiotów, jazda na rowerze w stałym tempie lub tenis deblowy? Nie wliczaj chodzenia.',
          required: true,
          genderForm: 'wykonywałeś',
          options: {
            'min': 0,
            'max': 7,
            'step': 1,
            'showMarkers': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_moderate_time',
          type: QuestionType.number,
          question: 'Ile czasu zazwyczaj poświęcałeś/-aś na umiarkowaną aktywność fizyczną w jeden z tych dni?',
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
          type: QuestionType.slider,
          question: 'W ciągu ostatnich 7 dni, przez ile dni chodziłeś/-aś co najmniej 10 minut jednorazowo?',
          required: true,
          genderForm: 'chodziłeś',
          options: {
            'min': 0,
            'max': 7,
            'step': 1,
            'showMarkers': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'ipaq_walking_time',
          type: QuestionType.number,
          question: 'Ile czasu zazwyczaj poświęcałeś/-aś na chodzenie w jeden z tych dni?',
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
          question: 'W ciągu ostatnich 7 dni, ile czasu spędzałeś/-aś siedząc w dzień roboczy?',
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



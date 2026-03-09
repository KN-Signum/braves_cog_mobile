import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningSQSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_SQ',
      title: 'Screening',
      questions: [
        // Info page
        SurveyQuestionEntity(
          id: 'sq_info',
          type: QuestionType.text,
          question: 'Następne pytania dotyczą Twoich typowych nawyków związanych ze snem wyłącznie w ciągu ostatniego miesiąca. Odpowiedzi powinny odzwierciedlać najbardziej trafną sytuację dla większości dni i nocy w ostatnim miesiącu.\n\nProsimy o udzielenie odpowiedzi na wszystkie pytania',
          required: false,
          options: {
            'info': true, // This is an info-only question, no input needed
          },
        ),
        // Q1: Godzina pójścia spać
        SurveyQuestionEntity(
          id: 'sq_bedtime',
          type: QuestionType.number,
          question: 'W ciągu ostatniego miesiąca, o której godzinie zazwyczaj kładłeś się spać w nocy?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 23,
            'maxMinutes': 59,
          },
        ),
        // Q2: Godzina wstania
        SurveyQuestionEntity(
          id: 'sq_waketime',
          type: QuestionType.number,
          question: 'W ciągu ostatniego miesiąca, o której godzinie zazwyczaj wstawałeś rano?',
          required: true,
          options: {
            'composite': 'hours_minutes',
            'maxHours': 23,
            'maxMinutes': 59,
          },
        ),
        // Q3: Czas zaśnięcia (minuty)
        SurveyQuestionEntity(
          id: 'sq_sleep_latency',
          type: QuestionType.number,
          question: 'W ciągu ostatniego miesiąca, ile czasu zazwyczaj zajmowało Ci zaśnięcie każdej nocy?',
          required: true,
          options: {
            'composite': 'single_minutes',
            'maxMinutes': 280,
          },
        ),
        // Q4: Godziny snu
        SurveyQuestionEntity(
          id: 'sq_sleep_hours',
          type: QuestionType.number,
          question: 'W ciągu ostatniego miesiąca, ile godzin rzeczywistego snu miałeś każdej nocy?\n(Może to się różnić od liczby godzin spędzonych w łóżku.)',
          required: true,
          options: {
            'composite': 'single_hours',
            'maxHours': 12,
          },
        ),
        // Q5: Trudności ze snem
        SurveyQuestionEntity(
          id: 'sq_sleep_difficulties',
          type: QuestionType.choice,
          question: 'W ciągu ostatniego miesiąca, czy miałeś trudności ze snem, ponieważ budziłeś się w środku nocy lub wcześnie rano?',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie w ostatnim miesiącu'},
              {'value': 'rarely', 'label': 'Rzadziej niż raz w tygodniu'},
              {'value': 'sometimes', 'label': 'Raz lub dwa razy w tygodniu'},
              {'value': 'often', 'label': 'Trzy razy w tygodniu lub częściej'},
            ],
          },
        ),
        // Q6: Jakość snu
        SurveyQuestionEntity(
          id: 'sq_sleep_quality',
          type: QuestionType.choice,
          question: 'W ciągu ostatniego miesiąca, jak ogólnie oceniasz jakość swojego snu?',
          required: true,
          options: {
            'options': [
              {'value': 'very_good', 'label': 'Bardzo dobra'},
              {'value': 'fairly_good', 'label': 'Dość dobra'},
              {'value': 'fairly_bad', 'label': 'Dość zła'},
              {'value': 'very_bad', 'label': 'Bardzo zła'},
            ],
          },
        ),
      ],
    );
  }
}


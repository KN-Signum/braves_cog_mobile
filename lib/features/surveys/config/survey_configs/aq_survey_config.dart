import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class AQSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_ASD',
      title: 'Autyzm (AQ)',
      questions: [
        SurveyQuestionEntity(
          id: 'aq_info',
          type: QuestionType.text,
          question:
              'Proszę odpowiedzieć na wszystkie pytania, nawet jeśli nie jesteś pewien/pewna odpowiedzi. Dla każdego pytania zaznacz odpowiedź, która najlepiej opisuje Ciebie.',
          required: false,
          options: {'info': true},
        ),
        // 1
        SurveyQuestionEntity(
          id: 'aq_1',
          type: QuestionType.choice,
          question: 'Wolę robić coś razem z innymi niż samemu',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 2
        SurveyQuestionEntity(
          id: 'aq_2',
          type: QuestionType.choice,
          question: 'Wolę wykonywać czynności zawsze w ten sam sposób',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 3
        SurveyQuestionEntity(
          id: 'aq_3',
          type: QuestionType.choice,
          question:
              'Gdy próbuję sobie coś wyobrazić, bez trudności potrafię stworzyć w umyśle tego obraz',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 4
        SurveyQuestionEntity(
          id: 'aq_4',
          type: QuestionType.choice,
          question:
              'Często jestem czymś tak bardzo pochłonięty/a, że zapominam o innych sprawach',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 5
        SurveyQuestionEntity(
          id: 'aq_5',
          type: QuestionType.choice,
          question:
              'Często zauważam nawet ciche dźwięki, których inni nie słyszą',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 6
        SurveyQuestionEntity(
          id: 'aq_6',
          type: QuestionType.choice,
          question:
              'Zwykle zauważam numery tablic samochodów lub podobne ciągi informacji',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 7
        SurveyQuestionEntity(
          id: 'aq_7',
          type: QuestionType.choice,
          question:
              'Inni ludzie często mówią mi, że to, co powiedziałem/am było niegrzeczne, chociaż ja tego nie dostrzegam',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 8
        SurveyQuestionEntity(
          id: 'aq_8',
          type: QuestionType.choice,
          question:
              'Kiedy czytam jakąś historię, mogę z łatwością wyobrazić sobie jej bohaterów',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 9
        SurveyQuestionEntity(
          id: 'aq_9',
          type: QuestionType.choice,
          question: 'Fascynują mnie daty',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 10
        SurveyQuestionEntity(
          id: 'aq_10',
          type: QuestionType.choice,
          question:
              'Będąc w grupie, potrafię z łatwością śledzić rozmowy kilku osób równocześnie',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 11
        SurveyQuestionEntity(
          id: 'aq_11',
          type: QuestionType.choice,
          question: 'Dobrze się czuję, będąc z innymi ludźmi',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 12
        SurveyQuestionEntity(
          id: 'aq_12',
          type: QuestionType.choice,
          question:
              'Mam tendencję do dostrzegania szczegółów, których inni nie widzą',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 13
        SurveyQuestionEntity(
          id: 'aq_13',
          type: QuestionType.choice,
          question: 'Wolę raczej pójść do biblioteki niż na zabawę',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 14
        SurveyQuestionEntity(
          id: 'aq_14',
          type: QuestionType.choice,
          question: 'Z łatwością wymyślam rozmaite historie',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 15
        SurveyQuestionEntity(
          id: 'aq_15',
          type: QuestionType.choice,
          question: 'Bardziej pociągają mnie ludzie niż rzeczy',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 16
        SurveyQuestionEntity(
          id: 'aq_16',
          type: QuestionType.choice,
          question:
              'Mam wyraźnie określone zainteresowania i złości mnie, kiedy nie mogę ich realizować',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 17
        SurveyQuestionEntity(
          id: 'aq_17',
          type: QuestionType.choice,
          question: 'Lubię towarzyskie pogaduszki',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 18
        SurveyQuestionEntity(
          id: 'aq_18',
          type: QuestionType.choice,
          question:
              'Kiedy coś mówię, innym ludziom nie zawsze łatwo jest coś wtrącić',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 19
        SurveyQuestionEntity(
          id: 'aq_19',
          type: QuestionType.choice,
          question: 'Fascynują mnie liczby',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 20
        SurveyQuestionEntity(
          id: 'aq_20',
          type: QuestionType.choice,
          question:
              'Kiedy czytam jakąś opowieść, trudno mi odgadnąć intencje jej bohaterów',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 21
        SurveyQuestionEntity(
          id: 'aq_21',
          type: QuestionType.choice,
          question:
              'Czytanie beletrystyki не sprawia mi szczególnej przyjemności',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 22
        SurveyQuestionEntity(
          id: 'aq_22',
          type: QuestionType.choice,
          question: 'Nawiązywanie nowych przyjaźni sprawia mi trudność',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej nie się zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 23
        SurveyQuestionEntity(
          id: 'aq_23',
          type: QuestionType.choice,
          question:
              'Nieustannie zauważam, że różne rzeczy układają się według powtarzających się schematów, wzorów',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 24
        SurveyQuestionEntity(
          id: 'aq_24',
          type: QuestionType.choice,
          question: 'Wolałbym/ałabym raczej pójść do teatru niż do muzeum',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
        // 25
        SurveyQuestionEntity(
          id: 'aq_25',
          type: QuestionType.choice,
          question:
              'Nie denerwuje mnie, gdy mój codzienny rozkład zajęć zostaje zakłócony',
          required: true,
          options: {
            'options': [
              {
                'value': 'definitely_agree',
                'label': 'Zdecydowanie się zgadzam',
              },
              {'value': 'slightly_agree', 'label': 'Raczej się zgadzam'},
              {'value': 'slightly_disagree', 'label': 'Raczej się nie zgadzam'},
              {
                'value': 'definitely_disagree',
                'label': 'Zdecydowanie się nie zgadzam',
              },
            ],
          },
        ),
      ],
    );
  }
}

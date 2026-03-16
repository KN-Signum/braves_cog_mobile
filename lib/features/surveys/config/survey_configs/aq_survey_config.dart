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
          question: 'Styl funkcjonowania',
          description:
              'Poniższe stwierdzenia dotyczą Twoich typowych zachowań, preferencji i sposobów przetwarzania informacji.\n\n'
              'Nie ma tu odpowiedzi dobrych ani złych — zaznacz tę opcję, która najlepiej opisuje Ciebie, a nie to, jak chciałbyś być postrzegany.\n\n'
              'Szacowany czas: ok. 5–8 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
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
              'Często jestem czymś tak bardzo pochłonięty, że zapominam o innych sprawach',
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
              'Inni ludzie często mówią mi, że to, co powiedziałem było niegrzeczne, chociaż ja tego nie dostrzegam',
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
              'Czytanie beletrystyki nie sprawia mi szczególnej przyjemności',
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
          question: 'Wolałbym raczej pójść do teatru niż do muzeum',
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
        // 26
        SurveyQuestionEntity(
          id: 'aq_26',
          type: QuestionType.choice,
          question:
              'Często zauważam, że nie wiem, jak podtrzymać rozmowę',
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
        // 27
        SurveyQuestionEntity(
          id: 'aq_27',
          type: QuestionType.choice,
          question:
              'Z łatwością odczytuję treści zawarte między wierszami, gdy ktoś do mnie mówi',
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
        // 28
        SurveyQuestionEntity(
          id: 'aq_28',
          type: QuestionType.choice,
          question:
              'Zwykle koncentruję się bardziej na całym obrazie niż na drobnych szczegółach',
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
        // 29
        SurveyQuestionEntity(
          id: 'aq_29',
          type: QuestionType.choice,
          question:
              'Nie jestem zbyt dobry w zapamiętywaniu numerów telefonów',
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
        // 30
        SurveyQuestionEntity(
          id: 'aq_30',
          type: QuestionType.choice,
          question:
              'Zwykle nie zauważam drobnych zmian w jakiejś sytuacji lub w czyimś wyglądzie',
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
        // 31
        SurveyQuestionEntity(
          id: 'aq_31',
          type: QuestionType.choice,
          question:
              'Potrafię zauważyć, że osoba, która mnie słucha staje się znudzona',
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
        // 32
        SurveyQuestionEntity(
          id: 'aq_32',
          type: QuestionType.choice,
          question:
              'Potrafię robić kilka rzeczy równocześnie',
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
        // 33
        SurveyQuestionEntity(
          id: 'aq_33',
          type: QuestionType.choice,
          question:
              'Gdy rozmawiam przez telefon, nie jestem pewny, kiedy nadchodzi moja kolej, żeby mówić',
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
        // 34
        SurveyQuestionEntity(
          id: 'aq_34',
          type: QuestionType.choice,
          question:
              'Lubię robić różne rzeczy spontanicznie',
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
        // 35
        SurveyQuestionEntity(
          id: 'aq_35',
          type: QuestionType.choice,
          question:
              'Często jako ostatni rozumiem sens dowcipu',
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
        // 36
        SurveyQuestionEntity(
          id: 'aq_36',
          type: QuestionType.choice,
          question:
              'Potrafię z łatwością odgadnąć, co ktoś myśli lub czuje, po prostu patrząc na jego twarz',
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
        // 37
        SurveyQuestionEntity(
          id: 'aq_37',
          type: QuestionType.choice,
          question:
              'Potrafię bardzo szybko powrócić do czynności, którą coś mi przerwało',
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
        // 38
        SurveyQuestionEntity(
          id: 'aq_38',
          type: QuestionType.choice,
          question:
              'Dobrze sobie radzę z towarzyskimi pogaduszkami',
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
        // 39
        SurveyQuestionEntity(
          id: 'aq_39',
          type: QuestionType.choice,
          question:
              'Ludzie często zwracają mi uwagę, że nieustannie mówię na ten sam temat',
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
        // 40
        SurveyQuestionEntity(
          id: 'aq_40',
          type: QuestionType.choice,
          question:
              'Kiedy byłem mały, przyjemność sprawiały mi zabawy z innymi dziećmi, w których trzeba było coś udawać',
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
        // 41
        SurveyQuestionEntity(
          id: 'aq_41',
          type: QuestionType.choice,
          question:
              'Lubię zbierać informacje na temat kategorii, do których należą różne rzeczy (np. marek samochodów, gatunków ptaków, rodzajów pociągów, roślin i innych)',
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
        // 42
        SurveyQuestionEntity(
          id: 'aq_42',
          type: QuestionType.choice,
          question:
              'Trudno jest mi wyobrazić sobie, jakby to było być kimś innym',
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
        // 43
        SurveyQuestionEntity(
          id: 'aq_43',
          type: QuestionType.choice,
          question:
              'Lubię starannie planować wszelkie zajęcia, w jakich biorę udział',
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
        // 44
        SurveyQuestionEntity(
          id: 'aq_44',
          type: QuestionType.choice,
          question:
              'Lubię spotkania towarzyskie',
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
        // 45
        SurveyQuestionEntity(
          id: 'aq_45',
          type: QuestionType.choice,
          question:
              'Rozpoznawanie intencji innych ludzi sprawia mi trudność',
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
        // 46
        SurveyQuestionEntity(
          id: 'aq_46',
          type: QuestionType.choice,
          question:
              'Nowe sytuacje wywołują we mnie niepokój',
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
        // 47
        SurveyQuestionEntity(
          id: 'aq_47',
          type: QuestionType.choice,
          question:
              'Lubię poznawać nowych ludzi',
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
        // 48
        SurveyQuestionEntity(
          id: 'aq_48',
          type: QuestionType.choice,
          question:
              'Jestem dobrym dyplomatą',
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
        // 49
        SurveyQuestionEntity(
          id: 'aq_49',
          type: QuestionType.choice,
          question:
              'Nie jestem zbyt dobry w zapamiętywaniu dat urodzin innych osób',
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
        // 50
        SurveyQuestionEntity(
          id: 'aq_50',
          type: QuestionType.choice,
          question:
              'Z łatwością bawię się z dziećmi w zabawy wymagające udawania',
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

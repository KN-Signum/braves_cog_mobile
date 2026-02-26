import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class Brief2WaySSSSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Social_Support',
      title: 'Wsparcie społeczne (Brief 2-Way SSS)',
      questions: [
        SurveyQuestionEntity(
          id: 'sss_info',
          type: QuestionType.text,
          question: 'Następne stwierdzenia dotyczą twoich doświadczeń, odczuć oraz sposobu funkcjonowania w różnych sytuacjach związanych z cechami ze spektrum autyzmu. Przeczytaj uważnie każde stwierdzenie i zaznacz, w jakim stopniu jest ono na ogół prawdziwe w Twoim przypadku. Nie ma odpowiedzi dobrych ani złych — ważne jest, aby odpowiedzi były zgodne z Twoimi osobistymi doświadczeniami.',
          required: false,
          options: {
            'info': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_1',
          type: QuestionType.choice,
          question: 'Gdybym gdzieś utknął/utknęła, jest ktoś, kto mógłby po mnie przyjechać',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_2',
          type: QuestionType.choice,
          question: 'Pomagam innym, gdy są zbyt zajęci, żeby ze wszystkim zdążyć',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_3',
          type: QuestionType.choice,
          question: 'Ludzie zwierzają mi się, gdy mają problemy',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_4',
          type: QuestionType.choice,
          question: 'Inni zwracają się do mnie po pomoc w różnych sprawach/zadaniach',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_5',
          type: QuestionType.choice,
          question: 'Potrafię dać innym poczucie otuchy i wsparcia, kiedy tego potrzebują',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_6',
          type: QuestionType.choice,
          question: 'Jest w moim życiu ktoś, od kogo mogę uzyskać wsparcie emocjonalne',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_7',
          type: QuestionType.choice,
          question: 'Bliskie mi osoby opowiadają mi o swoich lękach i zmartwieniach',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_8',
          type: QuestionType.choice,
          question: 'Pomagałem/pomagałam komuś przejąć jego obowiązki, gdy nie mógł ich wypełnić',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_9',
          type: QuestionType.choice,
          question: 'Kiedy mam gorszy nastrój, jest ktoś, na kim mogę się oprzeć',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_10',
          type: QuestionType.choice,
          question: 'Jest przynajmniej jedna osoba, z którą mogę dzielić się większością spraw',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_11',
          type: QuestionType.choice,
          question: 'Mam kogoś, kto pomoże mi, gdy źle się czuję lub jestem chory/chora',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'sss_12',
          type: QuestionType.choice,
          question: 'Jest ktoś, kto może pomóc mi z moimi obowiązkami, gdy sam/sama nie dam rady',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często'},
              {'value': 4, 'label': 'Prawie zawsze'},
              {'value': 5, 'label': 'Zawsze'},
            ],
          },
        ),
      ],
    );
  }
}








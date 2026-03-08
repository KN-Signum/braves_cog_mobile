import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class AQSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Followup_AQ',
      title: 'ASRS',
      questions: [
        SurveyQuestionEntity(
          id: 'asrs_info',
          type: QuestionType.text,
          question:
              'Proszę odpowiedzieć na wszystkie pytania, nawet jeśli nie jesteś pewien odpowiedzi. Dla każdego pytania zaznacz odpowiedź, która najlepiej opisuje Ciebie.',
          required: false,
          options: {'info': true},
        ),
        // 1
        SurveyQuestionEntity(
          id: 'asrs_1',
          type: QuestionType.choice,
          question: 'Jak często masz trudności, z dopracowaniem szczegółów jakiegoś zadania, po tym jak już je prawie wykonałeś?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 2
        SurveyQuestionEntity(
          id: 'asrs_2',
          type: QuestionType.choice,
          question: 'Jak często masz trudności w planowaniu i organizowaniu skomplikowanych zadań?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 3
        SurveyQuestionEntity(
          id: 'asrs_3',
          type: QuestionType.choice,
          question: 'Jak często zapominasz o spotkaniach lub codziennych obowiązkach?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 4        
        SurveyQuestionEntity(
          id: 'asrs_4',
          type: QuestionType.choice,
          question: 'Jak często unikasz lub odkładasz zadania wymagające długotrwałego wysiłku umysłowego?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 5              
        SurveyQuestionEntity(
          id: 'asrs_5',
          type: QuestionType.choice,
          question: 'Jak często masz nerwowe ruchy rąk lub stóp, gdy musisz siedzieć przez dłuższy czas?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),        
        // 6
        SurveyQuestionEntity(
          id: 'asrs_6',
          type: QuestionType.choice,
          question: 'Jak często zdarza Ci się czuć tak pobudzonym, że masz ochotę robić wiele rzeczy na raz, jakbyś był „nakręcony”?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ), 
        // 7
        SurveyQuestionEntity(
          id: 'asrs_7',
          type: QuestionType.choice,
          question: 'Jak często popełniasz błędy wynikające z nieuwagi, podczas pracy nad nudnym lub trudnym projektem?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 8
        SurveyQuestionEntity(
          id: 'asrs_8',
          type: QuestionType.choice,
          question: 'Jak często masz problem z utrzymaniem uwagi nad zadaniami, które są nudne lub rutynowe?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 9
        SurveyQuestionEntity(
          id: 'asrs_9',
          type: QuestionType.choice,
          question: 'Jak często masz problem z utrzymaniem uwagi na tym, co ludzie mówią, nawet jeśli mówią bezpośrednio do Ciebie?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),  
        // 10
        SurveyQuestionEntity(
          id: 'asrs_10',
          type: QuestionType.choice,
          question: 'Jak często gubisz, odkładasz rzeczy w niewłaściwe miejsce lub masz trudności ze znalezieniem ich, zarówno w pracy, jak i w domu?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 11
        SurveyQuestionEntity(
          id: 'asrs_11',
          type: QuestionType.choice,
          question: 'Jak często rozpraszają Cię różne aktywności lub dźwięki wokół Ciebie?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),    
        // 12
        SurveyQuestionEntity(
          id: 'asrs_12',
          type: QuestionType.choice,
          question: 'Jak często wstajesz z miejsca w sytuacjach wymagających długiego siedzenia, takich jak praca, spotkania czy wykłady?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 13
        SurveyQuestionEntity(
          id: 'asrs_13',
          type: QuestionType.choice,
          question: 'Jak często masz poczucie „wewnętrznego niepokoju”?S',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 14
        SurveyQuestionEntity(
          id: 'asrs_14',
          type: QuestionType.choice,
          question: 'Jak często masz trudności z rozluźnieniem się i relaksem, kiedy masz czas dla siebie?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 15
        SurveyQuestionEntity(
          id: 'asrs_15',
          type: QuestionType.choice,
          question: 'Jak często zdarza Ci się mówić zbyt dużo (być nadmiernie gadatliwym) w sytuacjach społecznych?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 16   
        SurveyQuestionEntity(
          id: 'asrs_16',
          type: QuestionType.choice,
          question: 'Jak często zdarza Ci się, że podczas rozmowy z innymi kończysz za kogoś wypowiedź, zanim on zdąży to zrobić?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 17
        SurveyQuestionEntity(
          id: 'asrs_17',
          type: QuestionType.choice,
          question: 'Jak często podczas rozmowy masz trudność z czekaniem na swoją kolej?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
          // 18 
        SurveyQuestionEntity(
          id: 'asrs_18',
          type: QuestionType.choice,
          question: 'Jak często zdarza Ci się przeszkadzać lub przerywać innym, gdy są zajęci?',
          required: true,
          options: {
            'options': [
              {'value': 0,'label': 'Nigdy',},
              {'value': 1, 'label': 'Rzadko'},
              {'value': 2, 'label': 'Czasami'},
              {'value': 3, 'label': 'Często',},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
      ],
    );
  }
}

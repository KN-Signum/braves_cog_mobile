import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class MiniEatOnboardingSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'MINI_EAT_OB',
      title: 'Mini eat',
      questions: [
        SurveyQuestionEntity(
          id: 'meob_info',
          type: QuestionType.text,
          question: 'Nawyki żywieniowe',
          description:
              'W tej sekcji zapytamy Cię o to, jak często spożywasz różne grupy produktów spożywczych.\n\n'
              'Pytania dotyczą typowego sposobu odżywiania — odpowiadaj zgodnie z tym, jak naprawdę wygląda Twoja dieta, a nie z tym, jak powinna wyglądać.\n\n'
              'Szacowany czas: ok. 4–6 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_fruits',
          type: QuestionType.choice,
          question: 'Jak często jesz świeże owoce?',
          description: 'Przykłady: jabłka, banany, gruszki, pomarańcze, winogrona, truskawki, borówki itp.\nUwzględnij świeże i mrożone owoce bez dodatku cukru.\nNie wliczaj owoców suszonych, konserwowanych ani soków owocowych.\nJedna porcja = 1 małe jabłko lub ½ dużego banana (ok. 1 szklanka, wielkość małej pięści); 1 szklanka mandarynek/pomarańczy; 1 szklanka melona lub malin; ¾ szklanki borówek; ½ szklanki pokrojonych truskawek.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_vegetables',
          type: QuestionType.choice,
          question: 'Jak często jesz warzywa?',
          description: 'Przykłady: pomidory, papryka, ogórki, brokuły, marchew, fasolka szparagowa, kapusta, szpinak, rukola i inne warzywa liściaste.\nUwzględnij surowe lub gotowane warzywa nieskrobiowe.\nNie wliczaj ziemniaków ani warzyw suszonych.\nJedna porcja = 1 szklanka surowych warzyw (np. pomidory, małe marchewki, seler, zielony groszek); ½ szklanki gotowanych warzyw (np. brokuły, szpinak); 1 szklanka rukoli.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_legumes_nuts',
          type: QuestionType.choice,
          question: 'Jak często jesz rośliny strączkowe, orzechy i nasiona?',
          description: 'Przykłady:\nStrączki – fasola, soczewica, ciecierzyca, groch, soja, tempeh, hummus.\nOrzechy – migdały, orzechy włoskie, laskowe, ziemne.\nNasiona – sezam, słonecznik, pestki dyni, siemię lniane.\nJedna porcja = ½ szklanki gotowanych strączków; ⅓ szklanki hummusu lub pasty z fasoli; ½ szklanki tofu; ¼ szklanki tempehu; mała garść orzechów lub nasion.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_fish',
          type: QuestionType.choice,
          question: 'Jak często jesz ryby lub owoce morza?',
          description: 'Przykłady: łosoś, sardynki, pstrąg, makrela, tuńczyk; uwzględnij również ryby konserwowe.\nJedna porcja = ok. 90 g gotowanej lub konserwowej ryby (wielkość talii kart) lub kawałek surowej ryby wielkości dłoni.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_whole_grains',
          type: QuestionType.choice,
          question: 'Jak często jesz produkty pełnoziarniste?',
          description: 'Przykłady: chleb pełnoziarnisty, płatki owsiane, musli, brązowy ryż, pełnoziarnisty makaron, kasze, tortilla kukurydziana.\nNie wliczaj białego pieczywa, białego ryżu ani zwykłego makaronu.\nJedna porcja = 1 kromka chleba pełnoziarnistego; ½ szklanki ugotowanych płatków/ryżu/kaszy/makaronu; 1 mała tortilla kukurydziana; 1 szklanka gotowych płatków śniadaniowych.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_refined_grains',
          type: QuestionType.choice,
          question: 'Jak często jesz produkty z rafinowanych zbóż?',
          description: 'Przykłady: biały chleb, bułki, bajgle, biały ryż, zwykły makaron, tortilla pszenna.\nNie wliczaj produktów pełnoziarnistych.\nJedna porcja = 1 kromka białego chleba; ½ bułki/bajgla; ½ szklanki ugotowanego białego ryżu lub makaronu.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_low_fat_dairy',
          type: QuestionType.choice,
          question: 'Jak często spożywasz niskotłuszczowe produkty mleczne?',
          description: 'Przykłady: mleko 0–1%, jogurt naturalny light, mleko sojowe, twaróg chudy, mozzarella light.\nJedna porcja = 1 szklanka mleka niskotłuszczowego; ¾ szklanki jogurtu; 1 plaster sera light; ½ szklanki mozzarelli light.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_full_fat_dairy',
          type: QuestionType.choice,
          question: 'Jak często spożywasz pełnotłuste produkty mleczne i tłuszcze nasycone?',
          description: 'Przykłady: mleko 2% i pełne, masło, śmietana, sery żółte, lody, olej kokosowy, smalec.\nJedna porcja = 1 szklanka mleka pełnego; ¾ szklanki jogurtu pełnotłustego; 1 plaster sera; 2 łyżki lodów; 1 łyżeczka masła lub tłuszczu.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'meob_sweets',
          type: QuestionType.choice,
          question: 'Jak często jesz słodycze i słodkie przekąski?',
          description: 'Przykłady: cukierki, ciastka, ciasta, pączki, batoniki, słodkie przekąski.\nJedna porcja = 1,5 kostki czekolady; 3 małe cukierki; 1 małe ciastko; 1 pączek; 1 słodka przekąska.',
          required: true,
          options: {
            'options': [
              {'value': 'never', 'label': 'Nie jem wcale'},
              {'value': 'less_than_weekly', 'label': 'Rzadziej niż 1 porcja tygodniowo'},
              {'value': '1_2_weekly', 'label': '1–2 porcje tygodniowo'},
              {'value': '3_4_weekly', 'label': '3–4 porcje tygodniowo'},
              {'value': '5_6_weekly', 'label': '5–6 porcji tygodniowo'},
              {'value': '1_daily', 'label': '1 porcja dziennie'},
              {'value': '2_3_daily', 'label': '2–3 porcje dziennie'},
              {'value': '4_5_daily', 'label': '4–5 porcji dziennie'},
              {'value': '6_plus_daily', 'label': '6 lub więcej porcji dziennie'},
            ],
          },
        ),
      ],
    );
  }
}


class SurveyAlert {
  final String title;
  final String message;

  SurveyAlert({required this.title, required this.message});
}

class SurveyAlertManager {
  /// Ankiety, w których po wypełnieniu pokazywany jest alert (PHQ-2, GAD-2, PHQ-9, GAD-7).
  /// Po pojawieniu się alertu użytkownik nie może cofać się do pytań tej ankiety.
  static bool isAlertSurvey(String surveyId) {
    if (surveyId == 'PHQ_2' || surveyId == 'GAD_2') return true;
    if (surveyId == 'Baseline_Depression' ||
        surveyId.contains('PHQ_9') ||
        surveyId.contains('phq9')) {
      return true;
    }
    if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
        surveyId.contains('GAD_7') ||
        surveyId.contains('gad7')) {
      return true;
    }
    return false;
  }

  static SurveyAlert? getAlertForSurvey(
    String surveyId,
    Map<String, dynamic> answers,
  ) {
    int getIntAnswer(String key) {
      final value = answers[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
      return 0;
    }

    // PHQ-2
    if (surveyId == 'PHQ_2') {
      final score = getIntAnswer('phq2_1') + getIntAnswer('phq2_2');
      if (score < 3) {
        return SurveyAlert(
          title: 'Alert informacyjny',
          message:
              'Twój wynik wykonanego testu nie wskazuje obecnie na podwyższone objawy obniżonego nastroju. Ten wynik pochodzi z kwestionariusza przesiewowego i nie stanowi diagnozy.',
        );
      }
      return SurveyAlert(
        title: 'Alert ostrzegawczy',
        message:
            'Twój wynik wykonanego testu sugeruje podwyższone objawy obniżonego nastroju w ostatnich dwóch tygodniach. Nie jest to diagnoza, ale sygnał, że warto rozważyć dalszą ocenę lub rozmowę ze specjalistą. Jeśli potrzebujesz wsparcia, przejdź do ustawień i zakładki „Uzyskaj pomoc".',
      );
    }

    // GAD-2
    if (surveyId == 'GAD_2') {
      final score = getIntAnswer('gad2_1') + getIntAnswer('gad2_2');
      if (score < 3) {
        return SurveyAlert(
          title: 'Alert informacyjny',
          message:
              'Twój wynik wykonanego testu nie wskazuje obecnie na podwyższy poziom objawów lękowych. Ten wynik nie stanowi diagnozy.',
        );
      }
      return SurveyAlert(
        title: 'Alert ostrzegawczy',
        message:
            'Twój wynik wykonanego testu sugeruje podwyższony poziom objawów lękowych w ostatnich dwóch tygodniach. Nie jest to diagnoza, ale sygnał, że warto rozważyć dalszą ocenę lub kontakt ze specjalistą. W ustawieniach w zakładce „Uzyskaj pomoc" znajdziesz dostępne formy wsparcia.',
      );
    }

    // PHQ-9
    if (surveyId == 'Baseline_Depression' ||
        surveyId.contains('PHQ_9') ||
        surveyId.contains('phq9')) {
      int score = 0;
      for (int i = 1; i <= 9; i++) {
        score += getIntAnswer('phq9_$i');
      }

      final q9Value = getIntAnswer('phq9_9');
      if (q9Value >= 1) {
        return SurveyAlert(
          title: 'Alert krytyczny',
          message:
              'Jedna z Twoich odpowiedzi wykonanego testu sugeruje obecność myśli o zrobieniu sobie krzywdy lub odebraniu sobie życia. Ten wynik nie jest diagnozą, ale sygnałem wymagającym natychmiastowego działania. Jeśli czujesz, że możesz być w niebezpieczeństwie, zadzwoń 112 lub 999. Szczegółowe numery wsparcia znajdziesz w ustawieniach w zakładce „Uzyskaj pomoc".',
        );
      } else if (score >= 20) {
        return SurveyAlert(
          title: 'Alert krytyczny',
          message:
              'Twój wynik wykonanego testu wskazuje na bardzo nasilone objawy depresyjne. Nie jest to diagnoza, jednak zalecany jest pilny kontakt ze specjalistą. W sytuacji nagłej skorzystaj z numerów dostępnych w ustawieniach w zakładce „Uzyskaj pomoc" lub zadzwoń 112 / 999.',
        );
      } else if (score >= 15) {
        return SurveyAlert(
          title: 'Alert wysoki',
          message:
              'Twój wynik wykonanego testu wskazuje na nasilone objawy depresyjne. Nie jest to diagnoza, ale zalecany jest kontakt ze specjalistą zdrowia psychicznego. Skorzystaj z informacji dostępnych w ustawieniach w zakładce „Uzyskaj pomoc".',
        );
      } else if (score >= 10) {
        return SurveyAlert(
          title: 'Alert podwyższony',
          message:
              'Twój wynik wykonanego testu wskazuje na umiarkowane objawy depresyjne. Nie jest to diagnoza, jednak zalecany jest kontakt ze specjalistą. W ustawieniach w zakładce „Uzyskaj pomoc" znajdziesz numery i kontakty do wsparcia.',
        );
      } else if (score >= 5) {
        return SurveyAlert(
          title: 'Alert ostrzegawczy',
          message:
              'Twój wynik wykonanego testu sugeruje łagodne objawy depresyjne. Nie jest to diagnoza. Jeśli objawy utrzymują się lub wpływają na codzienne funkcjonowanie, warto je monitorować lub skonsultować ze specjalistą. W razie potrzeby zajrzyj do ustawień do zakładki „Uzyskaj pomoc".',
        );
      }
      return SurveyAlert(
        title: 'Alert informacyjny',
        message:
            'Twój wynik wykonanego testu wskazuje na brak lub minimalne objawy depresyjne. Ten wynik pochodzi z narzędzia przesiewowego i nie stanowi diagnozy.',
      );
    }

    // GAD-7
    if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
        surveyId.contains('GAD_7') ||
        surveyId.contains('gad7')) {
      int score = 0;
      for (int i = 1; i <= 7; i++) {
        score += getIntAnswer('gad7_$i');
      }

      if (score >= 15) {
        return SurveyAlert(
          title: 'Alert wysoki',
          message:
              'Twój wynik wykonanego testu wskazuje na wysoki poziom objawów lękowych. Nie jest to diagnoza, ale zalecany jest kontakt z psychologiem lub psychiatrą. Skorzystaj z informacji dostępnych w ustawieniach w zakładce „Uzyskaj pomoc".',
        );
      } else if (score >= 10) {
        return SurveyAlert(
          title: 'Alert podwyższony',
          message:
              'Twój wynik wykonanego testu wskazuje na umiarkowany poziom objawów lękowych. Nie jest to diagnoza, jednak zaleca się kontakt ze specjalistą. Pomocne kontakty znajdziesz w ustawieniach w zakładce „Uzyskaj pomoc".',
        );
      } else if (score >= 5) {
        return SurveyAlert(
          title: 'Alert ostrzegawczy',
          message:
              'Twój wynik wykonanego testu sugeruje łagodny poziom objawów lękowych. Nie jest to diagnoza. Warto obserwować objawy i rozważyć strategie radzenia sobie ze stresem. Jeśli potrzebujesz wsparcia, zajrzyj do ustawień do zakładki „Uzyskaj pomoc".',
        );
      }
      return SurveyAlert(
        title: 'Alert informacyjny',
        message:
            'Twój wynik wykonanego testu nie wskazuje na istotne objawy lękowe. Ten wynik nie stanowi diagnozy.',
      );
    }

    if (surveyId == 'Baseline_ASD' ||
        surveyId == 'followup_AQ' ||
        surveyId.contains('AQ') ||
        surveyId.contains('aq')) {
      int score = 0;
      for (int i = 1; i <= 50; i++) {
        score += getIntAnswer('aq_$i');
      }

      if (score >= 32) {
        return SurveyAlert(
          title: 'Wynik AQ – informacja',
          message:
              'Twój wynik w kwestionariuszu AQ jest podwyższony. Ten wynik nie jest diagnozą, ale może wskazywać na obecność cech ze spektrum autyzmu. Jeśli chcesz, możesz omówić go ze specjalistą (psycholog/psychiatra).',
        );
      }

      return null;
    }

    return null;
  }
}

class GenderFormHelper {
  static String getVerbForm(String baseVerb, String genderIdentity) {
    switch (genderIdentity.toLowerCase()) {
      case 'male':
        if (baseVerb.endsWith('eś')) {
          return baseVerb;
        }
        if (baseVerb.endsWith('ł')) {
          return '${baseVerb}eś';
        }
        if (baseVerb.endsWith('ć')) {
          return '${baseVerb.substring(0, baseVerb.length - 1)}łeś';
        }
        return baseVerb;
      case 'female':
        if (baseVerb.endsWith('aś')) {
          return baseVerb;
        }
        if (baseVerb.endsWith('ł')) {
          return '${baseVerb}aś';
        }
        if (baseVerb.endsWith('ć')) {
          return '${baseVerb.substring(0, baseVerb.length - 1)}łaś';
        }
        return baseVerb;
      case 'non_binary':
      case 'other':
      case 'prefer_not_to_say':
      default:
        if (baseVerb.endsWith('o')) {
          return baseVerb;
        }
        if (baseVerb.endsWith('ł')) {
          return '${baseVerb}o';
        }
        if (baseVerb.endsWith('ć')) {
          return '${baseVerb.substring(0, baseVerb.length - 1)}ono';
        }
        return baseVerb;
    }
  }

  static String replaceGenderForm(String text, String genderIdentity) {
    switch (genderIdentity.toLowerCase()) {
      case 'male':
        return text.replaceAll('{genderForm}', 'mężczyzna');
      case 'female':
        return text.replaceAll('{genderForm}', 'kobieta');
      case 'non_binary':
      case 'other':
      case 'prefer_not_to_say':
      default:
        return text.replaceAll('{genderForm}', 'osoba');
    }
  }
}

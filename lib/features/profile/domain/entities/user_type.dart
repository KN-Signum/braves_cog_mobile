enum UserType {
  vasCog('VasCog'),
  neuroCog('NeuroCog'),
  covidCog('CovidCog'),
  sccCog('SCCCog'),
  normalCog('NormalCog');

  final String value;
  const UserType(this.value);

  static UserType fromString(String value) {
    final v = value.trim();

    // Backward compatibility (older cached / API values)
    switch (v.toUpperCase()) {
      case 'ADHD':
        return UserType.neuroCog;
      case 'COVID':
        return UserType.covidCog;
      case 'HYPERTENSION':
        return UserType.vasCog;
      case 'NORMAL':
        return UserType.normalCog;
    }

    // New values (case-insensitive match)
    final vLower = v.toLowerCase();
    return UserType.values.firstWhere(
      (e) => e.value.toLowerCase() == vLower,
      orElse: () => UserType.normalCog,
    );
  }
}

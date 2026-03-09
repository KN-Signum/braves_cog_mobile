enum EducationLevel {
  primary('primary'),
  vocational('vocational'),
  secondary('secondary'),
  higher('higher'),
  other('other');

  final String value;
  const EducationLevel(this.value);

  static EducationLevel fromString(String value) {
    final vLower = value.toLowerCase();
    return EducationLevel.values.firstWhere(
      (e) => e.value.toLowerCase() == vLower,
      orElse: () => EducationLevel.other,
    );
  }
}

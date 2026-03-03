enum BiologicalSex {
  male('male'),
  female('female');

  final String value;
  const BiologicalSex(this.value);

  static BiologicalSex fromString(String value) {
    final vLower = value.toLowerCase();
    return BiologicalSex.values.firstWhere(
      (e) => e.value.toLowerCase() == vLower,
      orElse: () => BiologicalSex.male,
    );
  }
}

enum UserType {
  adhd('ADHD'),
  covid('COVID'),
  hypertension('HYPERTENSION'),
  normal('NORMAL');

  final String value;
  const UserType(this.value);

  static UserType fromString(String value) {
    return UserType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserType.normal,
    );
  }
}

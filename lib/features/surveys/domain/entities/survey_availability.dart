/// Represents whether a recurring survey is currently available to the user.
class SurveyAvailability {
  /// Whether the user can fill the survey right now.
  final bool isAvailable;

  /// The earliest point in time when the survey becomes available again.
  /// `null` when the survey is already available.
  final DateTime? nextAvailableAt;

  const SurveyAvailability({required this.isAvailable, this.nextAvailableAt});
}

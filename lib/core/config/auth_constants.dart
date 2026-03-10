/// Authentication Constants for BRAVES-Cog Invite-Only System
class AuthConstants {
  /// Technical domain for user accounts
  static const String technicalDomain = '@bravescog.internal';

  /// Initial technical password provided by admin
  static const String initialTechnicalPassword = 'start123';

  /// Constructs the technical email from a user code
  static String getTechnicalEmail(String code) => '$code$technicalDomain';

  /// Extracts the user code from a technical email
  static String extractCodeFromEmail(String email) {
    return email.replaceAll(technicalDomain, '');
  }
}

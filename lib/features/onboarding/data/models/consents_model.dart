import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';

class ConsentsModel extends ConsentsEntity {
  const ConsentsModel({
    super.dataCollection,
    super.adverseEventsMonitoring,
    super.wantsAdverseEventsMonitoring,
    super.pushNotifications,
  });

  factory ConsentsModel.fromJson(Map<String, dynamic> json) {
    return ConsentsModel(
      dataCollection: json['dataCollection'] ?? true,
      adverseEventsMonitoring: json['adverseEventsMonitoring'] ?? true,
      wantsAdverseEventsMonitoring: json['wantsAdverseEventsMonitoring'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataCollection': dataCollection,
      'adverseEventsMonitoring': adverseEventsMonitoring,
      'wantsAdverseEventsMonitoring': wantsAdverseEventsMonitoring,
      'pushNotifications': pushNotifications,
      'lastUpdate': DateTime.now().toIso8601String(),
    };
  }
}

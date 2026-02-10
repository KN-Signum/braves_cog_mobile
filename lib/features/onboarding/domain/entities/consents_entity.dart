import 'package:equatable/equatable.dart';

class ConsentsEntity extends Equatable {
  final bool dataCollection;
  final bool adverseEventsMonitoring;
  final bool wantsAdverseEventsMonitoring;
  final bool pushNotifications;

  const ConsentsEntity({
    this.dataCollection = true,
    this.adverseEventsMonitoring = true,
    this.wantsAdverseEventsMonitoring = true,
    this.pushNotifications = true,
  });

  ConsentsEntity copyWith({
    bool? dataCollection,
    bool? adverseEventsMonitoring,
    bool? wantsAdverseEventsMonitoring,
    bool? pushNotifications,
  }) {
    return ConsentsEntity(
      dataCollection: dataCollection ?? this.dataCollection,
      adverseEventsMonitoring: adverseEventsMonitoring ?? this.adverseEventsMonitoring,
      wantsAdverseEventsMonitoring: wantsAdverseEventsMonitoring ?? this.wantsAdverseEventsMonitoring,
      pushNotifications: pushNotifications ?? this.pushNotifications,
    );
  }

  @override
  List<Object?> get props => [
        dataCollection,
        adverseEventsMonitoring,
        wantsAdverseEventsMonitoring,
        pushNotifications,
      ];
}

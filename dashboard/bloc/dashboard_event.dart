part of 'dashboard_bloc.dart';

/// Event for Dashboard Screen
@freezed
class DashboardEvent with _$DashboardEvent {
  /// Event to change questionnaire step
  const factory DashboardEvent.initial() = _DashboardInitialEvent;

  /// Event to change regeneration stage
  const factory DashboardEvent.onNextStage() = _DashboardOnNextStageEvent;
}

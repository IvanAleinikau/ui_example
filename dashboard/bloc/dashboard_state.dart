part of 'dashboard_bloc.dart';

/// Dashboard State
@freezed
class DashboardState with _$DashboardState {
  /// State when success occurs
  const factory DashboardState.success({
    required QuestionnaireEntity entity,
    required List<StageEntity> stages,
    required List<StageEntity> dashboardStages,
    required StageEntity closestCompletedStage,
    required ({int completedStage, int totalStages}) completedProgress,
  }) = _$DashboardSuccessState;

  /// State when loading occurs
  const factory DashboardState.loading() = _$DashboardLoadingState;

  /// State when paywall occurs
  const factory DashboardState.paywall() = _$DashboardPaywallState;
}

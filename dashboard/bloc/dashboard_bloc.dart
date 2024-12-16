import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quit_it_wl/domain/entity/questionnaire_entity.dart';
import 'package:quit_it_wl/domain/entity/stage_entity.dart';
import 'package:quit_it_wl/domain/use_cases/nothing.dart';
import 'package:quit_it_wl/domain/use_cases/questionnaire/questionnaire_get_use_case.dart';
import 'package:quit_it_wl/domain/use_cases/stage/get_stages_use_case.dart';
import 'package:quit_it_wl/presentation/utils/extension/int_extension.dart';

part 'dashboard_bloc.freezed.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

/// Data BLoC
@Injectable()
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// Default constructor.
  DashboardBloc(
    this._questionnaireGetUseCase,
    this._getStagesUseCase,
  ) : super(const DashboardState.loading()) {
    on<_DashboardInitialEvent>(_handleInitialEvent);
    on<_DashboardOnNextStageEvent>(_handleOnNextStageEvent);
  }

  final QuestionnaireGetUseCase _questionnaireGetUseCase;
  final GetStagesUseCase _getStagesUseCase;

  Future<void> _handleInitialEvent(
    _DashboardInitialEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final entity = await _questionnaireGetUseCase.call(Nothing());
    final stages = await _getStagesUseCase.call(Nothing());

    final data = _getLogicData(stages, entity.date);

    await Future.delayed(500.ms, () {}).whenComplete(() {
      emit(const DashboardState.paywall());
      emit(
        DashboardState.success(
          entity: entity,
          stages: stages,
          closestCompletedStage: data.closestStage,
          completedProgress: (completedStage: data.completedStages, totalStages: stages.length),
          dashboardStages: data.dashboardStages,
        ),
      );
    });
  }

  Future<void> _handleOnNextStageEvent(
    _DashboardOnNextStageEvent event,
    Emitter<DashboardState> emit,
  ) async {
    state.mapOrNull(
      success: (state) {
        final data = _getLogicData(state.stages, state.entity.date);

        emit(
          state.copyWith(
            closestCompletedStage: data.closestStage,
            completedProgress: (completedStage: data.completedStages, totalStages: state.stages.length),
            dashboardStages: data.dashboardStages,
          ),
        );
      },
    );
  }

  ({StageEntity closestStage, int completedStages, List<StageEntity> dashboardStages}) _getLogicData(
    List<StageEntity> stages,
    DateTime date,
  ) {
    StageEntity? closestCompletedStage;
    var completedStages = 0;
    var dashboardStages = <StageEntity>[];

    final diffInMs = DateTime.now().difference(date).inMilliseconds;

    for (final stage in stages) {
      final diff = diffInMs / stage.timelineMs;
      if (diff < 1) {
        closestCompletedStage ??= stage;
      } else {
        completedStages++;
      }
    }

    final totalStages = stages.length;
    if (closestCompletedStage == null || completedStages == totalStages - 1 || completedStages == totalStages - 2) {
      dashboardStages = stages.getRange(totalStages - 3, totalStages).toList();
    } else {
      if (completedStages == 0) {
        dashboardStages = stages.getRange(0, 3).toList();
      } else {
        for (var i = 0; i <= stages.length; i++) {
          final diff = diffInMs / stages[i].timelineMs;
          if (diff < 1) {
            dashboardStages = stages.getRange(i, i + 3).toList();
            break;
          }
        }
      }
    }

    return (
      closestStage: closestCompletedStage ?? stages.last,
      completedStages: completedStages,
      dashboardStages: dashboardStages,
    );
  }
}

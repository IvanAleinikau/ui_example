import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quit_it_wl/domain/entity/stage_entity.dart';
import 'package:quit_it_wl/presentation/components/buttons/app_icon_button.dart';
import 'package:quit_it_wl/presentation/screens/dashboard/widgets/regeneration_component.dart';
import 'package:quit_it_wl/presentation/utils/extension/build_context_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/int_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/num_extension.dart';
import 'package:quit_it_wl/presentation/utils/theme/app_images.dart';
import 'package:quit_it_wl/presentation/utils/theme/app_styles.dart';
import 'package:quit_it_wl/presentation/utils/theme/palette.dart';

part 'header_components/info_component.dart';

part 'header_components/time_counting_component.dart';

/// Dashboard Header
class DashboardHeader extends StatelessWidget {
  /// Default constructor
  const DashboardHeader({
    super.key,
    required this.closestCompletedStage,
    required this.startDate,
    required this.onNextStage,
    required this.progress,
    required this.regenerationTime,
  });

  /// Closest completed stage
  final StageEntity closestCompletedStage;

  /// Start date of use app
  final DateTime startDate;

  /// Setup next stage
  final VoidCallback onNextStage;

  /// Completed stages progress
  final ({int completedStage, int totalStages}) progress;

  /// Time for full regeneration
  final int regenerationTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 24),
            child: Align(
              alignment: Alignment.topRight,
              child: AppIconButton(
                onTap: () {},
                iconPath: AppImages.settings,
                backgroundColor: Palette.transparent,
                height: 24,
                width: 24,
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.height,
                Align(
                  child: Stack(
                    children: [
                      const _InfoComponent(),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _TimeCountingComponent(
                            startDate: startDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.height,
                RegenerationComponent(
                  closestCompletedStage: closestCompletedStage,
                  startDate: startDate,
                  onNextStage: onNextStage,
                  progress: progress,
                  regenerationTime: regenerationTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

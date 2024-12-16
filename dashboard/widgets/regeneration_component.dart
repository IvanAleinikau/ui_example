import 'dart:async';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quit_it_wl/domain/entity/stage_entity.dart';
import 'package:quit_it_wl/presentation/utils/extension/build_context_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/date_time_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/double_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/int_extension.dart';
import 'package:quit_it_wl/presentation/utils/extension/num_extension.dart';
import 'package:quit_it_wl/presentation/utils/theme/app_shadow.dart';
import 'package:quit_it_wl/presentation/utils/theme/app_styles.dart';
import 'package:quit_it_wl/presentation/utils/theme/palette.dart';

part 'regeneration_components/regeneration_progress.dart';

part 'regeneration_components/regeneration_stage.dart';

/// Regeneration Component
class RegenerationComponent extends StatefulWidget {
  /// Default constructor
  const RegenerationComponent({
    super.key,
    required this.closestCompletedStage,
    required this.startDate,
    required this.onNextStage,
    required this.progress,
    required this.regenerationTime,
  });

  /// Closest completed stage
  final StageEntity closestCompletedStage;

  /// Start date
  final DateTime startDate;

  /// Setup next stage
  final VoidCallback onNextStage;

  /// Completed stages progress
  final ({int completedStage, int totalStages}) progress;

  /// Time for full regeneration
  final int regenerationTime;

  @override
  State<RegenerationComponent> createState() => _RegenerationComponentState();
}

class _RegenerationComponentState extends State<RegenerationComponent> {
  final _componentNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _componentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expandableWidget = [
      _RegenerationStage(
        closestCompletedStage: widget.closestCompletedStage,
        startDate: widget.startDate,
        onNextStage: widget.onNextStage,
        isRegenerated: widget.progress.completedStage / widget.progress.totalStages == 1,
      ),
      _RegenerationProgress(
        progress: widget.progress,
        regenerationTime: widget.regenerationTime,
        startDate: widget.startDate,
        onNextStage: widget.onNextStage,
      ),
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            context.l10n.regeneration,
            style: AppStyles.regularBigStyle(
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Palette.secondary,
            ),
          ),
        ),
        ExpandablePageView(
          children: expandableWidget,
          onPageChanged: (index) => _componentNotifier.value = index,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder(
              valueListenable: _componentNotifier,
              builder: (_, activeIndex, __) {
                return _DotsIndicator(
                  childrenCount: expandableWidget.length,
                  activeIndex: activeIndex,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.childrenCount,
    required this.activeIndex,
  });

  final int childrenCount;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: activeIndex == index ? Palette.primary : Palette.lightSystemBlue,
              shape: BoxShape.circle,
            ),
          );
        },
        separatorBuilder: (_, __) => 12.width,
        itemCount: childrenCount,
      ),
    );
  }
}

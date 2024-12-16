import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quit_it_wl/domain/entity/stage_entity.dart';
import 'package:quit_it_wl/presentation/components/stage_item.dart';
import 'package:quit_it_wl/presentation/utils/extension/build_context_extension.dart';
import 'package:quit_it_wl/presentation/utils/navigation/app_router.gr.dart';
import 'package:quit_it_wl/presentation/utils/theme/app_styles.dart';
import 'package:quit_it_wl/presentation/utils/theme/palette.dart';

/// Dashboard stages
class DashboardStages extends StatelessWidget {
  /// Default constructor
  const DashboardStages({
    super.key,
    required this.stages,
    required this.startDate,
  });

  /// Dashboard stages
  final List<StageEntity> stages;

  /// Start date
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 430),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages.elementAt(index);

                return StageItem(
                  stage: stage,
                  startDate: startDate,
                  onTap: () => context.router.push(
                    StageRoute(
                      stage: stage,
                      startDate: startDate,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.stages,
                  style: AppStyles.regularBigStyle(
                    fontWeight: FontWeight.w600,
                    color: Palette.secondary,
                  ),
                ),
                InkWell(
                  onTap: () => context.router.push(const StagesRoute()),
                  borderRadius: BorderRadius.circular(5),
                  child: Text(
                    context.l10n.view_all,
                    style: AppStyles.regularNormalStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: Palette.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

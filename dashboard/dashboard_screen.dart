import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quit_it_wl/data/utilities/bloc/bloc_factory.dart';
import 'package:quit_it_wl/presentation/components/app_loading_widget.dart';
import 'package:quit_it_wl/presentation/components/dialogs/app_dialog.dart';
import 'package:quit_it_wl/presentation/components/dialogs/paywalls/app_paywall.dart';
import 'package:quit_it_wl/presentation/components/dialogs/paywalls/entity/paywall_price_entity.dart';
import 'package:quit_it_wl/presentation/components/dialogs/paywalls/enum/paywall_price_period.dart';
import 'package:quit_it_wl/presentation/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:quit_it_wl/presentation/screens/dashboard/widgets/dashboard_header.dart';
import 'package:quit_it_wl/presentation/screens/dashboard/widgets/dashboard_stages.dart';
import 'package:quit_it_wl/presentation/utils/theme/palette.dart';

/// DashboardScreen
@RoutePage()
class DashboardScreen extends StatelessWidget {
  /// Default constructor
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prices = [
      PaywallPriceEntity(period: PaywallPricePeriod.twelveMonths, monthlyPrice: 1.99, discount: 70),
      PaywallPriceEntity(period: PaywallPricePeriod.threeMonths, monthlyPrice: 3.99),
      PaywallPriceEntity(period: PaywallPricePeriod.monthly, monthlyPrice: 4.99),
    ];

    return Scaffold(
      backgroundColor: Palette.white,
      body: BlocProvider(
        create: (context) {
          const event = DashboardEvent.initial();
          return context.read<BlocFactory>().create<DashboardBloc>()..add(event);
        },
        child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            state.mapOrNull(
              paywall: (_) => AppDialog.show(context, dialog: AppPaywall(prices: prices)),
            );
          },
          buildWhen: (p, c) => c != const DashboardState.paywall(),
          builder: (context, state) {
            final bloc = context.read<DashboardBloc>();

            return state.map(
              paywall: (_) => const SizedBox.shrink(),
              loading: (_) => const AppLoadingWidget(),
              success: (state) => SafeArea(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        DashboardHeader(
                          closestCompletedStage: state.closestCompletedStage,
                          startDate: state.entity.date,
                          onNextStage: () => bloc.add(const DashboardEvent.onNextStage()),
                          progress: state.completedProgress,
                          regenerationTime: state.stages.last.timelineMs,
                        ),
                        DashboardStages(
                          stages: state.dashboardStages,
                          startDate: state.entity.date,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

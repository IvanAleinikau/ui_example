part of '../dashboard_header.dart';

class _TimeCountingComponent extends StatefulWidget {
  const _TimeCountingComponent({
    required this.startDate,
  });

  final DateTime startDate;

  @override
  State<_TimeCountingComponent> createState() => _TimeCountingComponentState();
}

class _TimeCountingComponentState extends State<_TimeCountingComponent> {
  final _timeNotifier = ValueNotifier(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(1.s, (_) {
        _timeNotifier.value = !_timeNotifier.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.accentPink,
        borderRadius: BorderRadius.circular(42),
      ),
      child: ValueListenableBuilder(
        valueListenable: _timeNotifier,
        builder: (_, __, ___) {
          final diff = _timeDifference(widget.startDate);

          return Text(
            context.l10n.time_counter(diff.d, diff.h, diff.m, diff.s),
            style: AppStyles.regularNormalStyle(
              fontWeight: FontWeight.w600,
              color: Palette.white,
              height: 1.2,
            ),
          );
        },
      ),
    );
  }

  ({int d, int h, int m, int s}) _timeDifference(DateTime startingDate) {
    final diff = DateTime.now().difference(startingDate);

    final hoursDiff = diff.inHours - (24 * diff.inDays);
    final minuteDiff = diff.inMinutes - ((1440 * diff.inDays) + (hoursDiff * 60));
    final secondsDiff = diff.inSeconds - ((86400 * diff.inDays) + (hoursDiff * 3600) + (minuteDiff * 60));

    return (d: diff.inDays.n(), h: hoursDiff.n(), m: minuteDiff.n(), s: secondsDiff.n());
  }
}

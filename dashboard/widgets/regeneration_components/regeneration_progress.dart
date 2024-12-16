part of '../regeneration_component.dart';

class _RegenerationProgress extends StatefulWidget {
  const _RegenerationProgress({
    required this.progress,
    required this.regenerationTime,
    required this.startDate,
    required this.onNextStage,
  });

  final ({int completedStage, int totalStages}) progress;
  final int regenerationTime;
  final DateTime startDate;
  final VoidCallback onNextStage;

  @override
  State<_RegenerationProgress> createState() => _RegenerationProgressState();
}

class _RegenerationProgressState extends State<_RegenerationProgress> {
  final _regenerationNotifier = ValueNotifier(false);
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(1.s, (_) {
        _regenerationNotifier.value = !_regenerationNotifier.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: _regenerationNotifier,
            builder: (_, __, ___) {
              final diff = _timeLeftDifference(widget.startDate, widget.regenerationTime);

              return RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  text: context.l10n.time_left,
                  style: AppStyles.regularNormalStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: Palette.secondary,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: context.l10n.time_counter(diff.d, diff.h, diff.m, diff.s),
                      style: AppStyles.regularNormalStyle(
                        fontWeight: FontWeight.w600,
                        color: Palette.accentPink,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          8.height,
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _regenerationNotifier,
              builder: (_, __, ___) {
                final diff = DateTime.now().difference(widget.startDate).inMilliseconds;

                final percent = (diff / widget.regenerationTime).toPercent();

                return Row(
                  children: [
                    _RegenerationItemWrapper(
                      title: '${widget.progress.completedStage}/${widget.progress.totalStages}',
                      subtitle: context.l10n.completed_progress,
                      child: FittedBox(
                        child: CircularPercentIndicator(
                          radius: 32,
                          startAngle: 90,
                          percent: widget.progress.completedStage / widget.progress.totalStages,
                          progressColor: Palette.accentGreen,
                          backgroundColor: Palette.lightGray,
                        ),
                      ),
                    ),
                    10.width,
                    _RegenerationItemWrapper(
                      title: '${(percent * 100).toStringAsFixed(2)}%',
                      subtitle: context.l10n.total_regenerated,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 16),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: LinearPercentIndicator(
                              width: 200,
                              lineHeight: 24,
                              percent: percent,
                              barRadius: const Radius.circular(8),
                              progressColor: Palette.accentPink,
                              backgroundColor: Palette.lightGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ({int d, int h, int m, int s}) _timeLeftDifference(DateTime startingDate, int timeMs) {
    if (widget.progress.completedStage / widget.progress.totalStages != 1) {
      widget.onNextStage();
    } else {
      _timer?.cancel();
    }

    final diff = DateTime.now().difference(startingDate);
    final timeLeft = Duration(milliseconds: timeMs) - diff;

    if (diff.inMilliseconds >= timeMs) return (d: 0, h: 0, m: 0, s: 0);

    final hoursDiff = diff.inHours - (24 * diff.inDays);
    final minuteDiff = diff.inMinutes - ((1440 * diff.inDays) + (hoursDiff * 60));
    final secondsDiff = diff.inSeconds - ((86400 * diff.inDays) + (hoursDiff * 3600) + (minuteDiff * 60));

    return (
      d: timeLeft.inDays,
      h: timeLeft.inHours - (timeLeft.inDays * 24),
      m: timeLeft.inMinutes - (timeLeft.inHours * 60),
      s: 60 - secondsDiff,
    );
  }
}

class _RegenerationItemWrapper extends StatelessWidget {
  const _RegenerationItemWrapper({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Palette.primaryBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Palette.lightBlue),
          boxShadow: [AppShadows.primaryActive],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.regularHugeStyle(
                    fontWeight: FontWeight.w600,
                    color: Palette.primary,
                    height: 1.2,
                  ),
                ),
                8.height,
                Text(
                  subtitle,
                  style: AppStyles.regularSmallStyle(
                    fontWeight: FontWeight.w600,
                    color: Palette.secondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            10.width,
            child,
          ],
        ),
      ),
    );
  }
}

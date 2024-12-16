part of '../regeneration_component.dart';

class _RegenerationStage extends StatefulWidget {
  const _RegenerationStage({
    required this.closestCompletedStage,
    required this.startDate,
    required this.onNextStage,
    required this.isRegenerated,
  });

  final StageEntity closestCompletedStage;
  final DateTime startDate;
  final VoidCallback onNextStage;
  final bool isRegenerated;

  @override
  State<_RegenerationStage> createState() => _RegenerationStageState();
}

class _RegenerationStageState extends State<_RegenerationStage> {
  final _stateNotifier = ValueNotifier(false);
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(1.s, (_) {
        _stateNotifier.value = !_stateNotifier.value;
      });
    });
    super.initState();
  }

  int _getPercent() {
    final difference = DateTime.now().difference(widget.startDate).inMilliseconds;
    final percent = ((difference / widget.closestCompletedStage.timelineMs) * 100).toInt();

    if (percent >= 100 && !widget.isRegenerated) widget.onNextStage();
    if (widget.isRegenerated) _timer?.cancel();

    return percent >= 100 ? 100 : percent.n();
  }

  String _getLeftTime(BuildContext context) {
    final diff =
        Duration(milliseconds: widget.closestCompletedStage.timelineMs) - DateTime.now().difference(widget.startDate);

    final hoursDiff = diff.inHours - (24 * diff.inDays);
    final minuteDiff = diff.inMinutes - ((1440 * diff.inDays) + (hoursDiff * 60));
    final secondsDiff = diff.inSeconds - ((86400 * diff.inDays) + (hoursDiff * 3600) + (minuteDiff * 60));

    if (diff.inDays <= 0) return context.l10n.regeneration_time_left(hoursDiff.nz(), minuteDiff.nz(), secondsDiff.nz());

    return context.l10n
        .regeneration_time_left_with_d(diff.inDays.n(), hoursDiff.nz(), minuteDiff.nz(), secondsDiff.nz());
  }

  @override
  Widget build(BuildContext context) {
    final regenerationDate = widget.startDate.add(Duration(milliseconds: widget.closestCompletedStage.timelineMs));

    return Container(
      height: 118,
      padding: const EdgeInsets.only(top: 12, left: 16, right: 12, bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Palette.primaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Palette.lightBlue),
        boxShadow: [AppShadows.primaryActive],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _stateNotifier,
                      builder: (_, __, ___) {
                        return Text(
                          '${_getPercent()}% ${widget.closestCompletedStage.name}',
                          maxLines: 2,
                          style: AppStyles.regularBigStyle(
                            fontWeight: FontWeight.w600,
                            color: Palette.primary,
                          ),
                        );
                      },
                    ),
                    4.height,
                    Text(
                      context.l10n.next_regeneration,
                      style: AppStyles.regularSmallStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: Palette.secondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Palette.accentPink,
                        borderRadius: BorderRadius.circular(42),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _stateNotifier,
                        builder: (_, __, ___) {
                          return Text(
                            _getLeftTime(context),
                            style: AppStyles.regularSmallStyle(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: Palette.white,
                            ),
                          );
                        },
                      ),
                    ),
                    12.width,
                    Text(
                      regenerationDate.ddMMHHmm(),
                      style: AppStyles.regularSmallStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: Palette.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.width,
          Image.asset(
            widget.closestCompletedStage.icon,
            height: 86,
            width: 86,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

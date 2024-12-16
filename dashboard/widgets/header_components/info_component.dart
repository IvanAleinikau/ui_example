part of '../dashboard_header.dart';

class _InfoComponent extends StatelessWidget {
  const _InfoComponent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: Palette.primaryBackground,
        shape: BoxShape.circle,
        border: Border.all(color: Palette.lightBlue),
        boxShadow: [
          BoxShadow(
            color: Palette.primaryShadow.withOpacity(0.57),
            blurRadius: 185,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Center(
          child: Text(
            context.l10n.i_am_clean,
            textAlign: TextAlign.center,
            style: AppStyles.regularCustomSizeStyle(
              fontSize: 46,
              color: Palette.primary,
            ),
          ),
        ),
      ),
    );
  }
}

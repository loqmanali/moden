import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modn/core/localization/bloc/locale_bloc.dart';
import 'package:modn/core/localization/widgets/language_selector.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    this.height = 150,
    this.radius = 0,
    this.topColor = const Color(0xFF4EB2B7),
    this.bottomColor = const Color(0xFF67C0C4),
    this.leftY = 0.35,
    this.rightY = 0.85,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.title,
    this.titleStyle,
    this.child,
    this.centerTitle = true,
    this.trailing,
    this.leading,
  });

  final double height;
  final double radius;
  final Color topColor;
  final Color bottomColor;
  final double leftY;
  final double rightY;
  final EdgeInsets padding;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final bool centerTitle;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: topColor),
            CustomPaint(
              painter: _BottomPolygonPainter(
                color: bottomColor,
                leftY: leftY,
                rightY: rightY,
              ),
            ),
            if (title != null || child != null)
              Padding(
                padding: padding,
                child: Align(
                  alignment:
                      centerTitle ? Alignment.centerLeft : Alignment.topLeft,
                  child: _buildHeaderContent(textTheme, context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(TextTheme textTheme, BuildContext context) {
    final content = child ??
        Text(
          title ?? '',
          style: titleStyle ??
              textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 28,
                height: 1.2,
              ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
        ],
        Flexible(child: content),
        const SizedBox(width: 12),
        _RightControls(
          trailing: trailing,
          onLanguageChanged: (value) {
            context
                .read<LocaleBloc>()
                .add(ChangeLocaleEvent(value.languageCode));
          },
        ),
      ],
    );
  }
}

class _RightControls extends StatelessWidget {
  const _RightControls({
    required this.onLanguageChanged,
    this.trailing,
  });

  final ValueChanged<Locale> onLanguageChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LanguageToggle(onChanged: onLanguageChanged),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}

class _BottomPolygonPainter extends CustomPainter {
  _BottomPolygonPainter({
    required this.color,
    required this.leftY,
    required this.rightY,
  });

  final Color color;
  final double leftY;
  final double rightY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height * leftY)
      ..lineTo(size.width, size.height * rightY)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomPolygonPainter old) =>
      old.color != color || old.leftY != leftY || old.rightY != rightY;
}

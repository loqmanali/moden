import 'package:flutter/material.dart';

/// {@template default_drop_indicator_template}
/// A default drop-style indicator widget for the bottom navigation bar.
///
/// Displays an animated drop-like indicator with a falling dot effect.
/// The indicator consists of a curved shape and an animated falling circle.
/// {@endtemplate}
class DefaultDropIndicator extends StatelessWidget {
  /// {@macro default_drop_indicator_template}
  ///
  /// Parameters:
  /// - [controller]: Animation controller for smooth transitions.
  /// - [selectedIndex]: The currently selected item index.
  /// - [previousIndex]: The previously selected item index.
  /// - [color]: The color of the indicator.
  /// - [itemCount]: Total number of navigation items.
  const DefaultDropIndicator({
    super.key,
    required this.controller,
    required this.selectedIndex,
    required this.previousIndex,
    required this.color,
    required this.itemCount,
  });

  /// The animation controller for smooth indicator movement and effects.
  final Animation<double> controller;

  /// The index of the currently selected navigation item.
  final int selectedIndex;

  /// The index of the previously selected navigation item.
  final int previousIndex;

  /// The color of the drop indicator.
  final Color color;

  /// The total number of items in the navigation bar.
  final int itemCount;

  /// {@template default_drop_indicator_build_template}
  /// Builds the animated drop indicator with falling dot effect.
  ///
  /// Calculates position based on item width and RTL support,
  /// then animates a curved shape and falling circle.
  ///
  /// Parameters:
  /// - [context]: The build context.
  ///
  /// Returns:
  /// An animated widget showing the drop indicator effect.
  /// {@endtemplate}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final deviceWidth = MediaQuery.sizeOf(context).width;
    final itemWidth = deviceWidth / itemCount;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    double start = previousIndex * itemWidth + itemWidth / 2;
    double end = selectedIndex * itemWidth + itemWidth / 2;
    if (isRTL) {
      start = deviceWidth - start;
      end = deviceWidth - end;
    }
    final offsetAnim = Tween<double>(begin: start, end: end).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.35)),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final x = offsetAnim.value - (itemWidth / 2);
        return Transform.translate(
          offset: Offset(x, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: itemWidth,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Drop shape (curved rectangle)
                  Opacity(
                    opacity: controller.value <= 0.7 ? 1.0 : 0.0,
                    child: Container(
                      width: 56,
                      height: 20,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: isDark
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  // Falling dot
                  Transform.translate(
                    offset: Tween<Offset>(
                      begin: const Offset(0, 6),
                      end: const Offset(0, 36),
                    )
                        .animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: const Interval(0.40, 0.70),
                          ),
                        )
                        .value,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            controller.value > 0.6 ? Colors.transparent : color,
                        shape: BoxShape.circle,
                        boxShadow: isDark && controller.value <= 0.6
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

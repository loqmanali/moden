import 'package:flutter/material.dart';

/// {@template default_underline_indicator_template}
/// A default underline indicator widget for the bottom navigation bar.
///
/// Displays an animated underline that moves between selected items.
/// The indicator is a horizontal bar that slides smoothly when selection changes.
/// {@endtemplate}
class DefaultUnderlineIndicator extends StatelessWidget {
  /// {@macro default_underline_indicator_template}
  ///
  /// Parameters:
  /// - [controller]: Animation controller for smooth transitions.
  /// - [selectedIndex]: The currently selected item index.
  /// - [previousIndex]: The previously selected item index.
  /// - [color]: The color of the indicator bar.
  /// - [itemCount]: Total number of navigation items.
  /// - [showDefaultIndicator]: Whether to show the indicator (default false).
  const DefaultUnderlineIndicator({
    super.key,
    required this.controller,
    required this.selectedIndex,
    required this.previousIndex,
    required this.color,
    required this.itemCount,
    this.showDefaultIndicator = false,
  });

  /// The animation controller for smooth indicator movement.
  final Animation<double> controller;

  /// The index of the currently selected navigation item.
  final int selectedIndex;

  /// The index of the previously selected navigation item.
  final int previousIndex;

  /// The color of the underline indicator.
  final Color color;

  /// The total number of items in the navigation bar.
  final int itemCount;

  /// Whether the default indicator should be visible.
  final bool showDefaultIndicator;

  /// {@template default_underline_indicator_build_template}
  /// Builds the animated underline indicator.
  ///
  /// Calculates the position based on item width and animates between
  /// previous and current selection positions.
  ///
  /// Parameters:
  /// - [context]: The build context.
  ///
  /// Returns:
  /// An animated widget showing the underline indicator or an empty box if disabled.
  /// {@endtemplate}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final width = MediaQuery.sizeOf(context).width / itemCount;
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    final begin = previousIndex * width;
    final end = selectedIndex * width;

    return showDefaultIndicator
        ? AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              final x =
                  Tween<double>(begin: begin, end: end).evaluate(animation);
              return Transform.translate(
                offset: Offset(x, 0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: width,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}

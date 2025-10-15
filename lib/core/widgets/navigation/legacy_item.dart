import 'package:flutter/material.dart';

import 'bottom_nav_item.dart';

/// {@template legacy_item_template}
/// A legacy navigation item widget that displays an icon and optional label.
///
/// Provides animated transitions between selected and unselected states,
/// with optional label visibility. Used for backward compatibility.
/// {@endtemplate}
class LegacyItem extends StatelessWidget {
  /// {@macro legacy_item_template}
  ///
  /// Parameters:
  /// - [item]: The BottomNavItem containing icon and label data.
  /// - [isSelected]: Whether this item is currently selected.
  /// - [active]: Color to use when selected.
  /// - [inactive]: Color to use when not selected.
  /// - [labelVisible]: Whether the label should be visible.
  const LegacyItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.active,
    required this.inactive,
    required this.labelVisible,
  });

  /// The navigation item data.
  final BottomNavItem item;

  /// Whether this item is selected.
  final bool isSelected;

  /// Color for selected state.
  final Color active;

  /// Color for unselected state.
  final Color inactive;

  /// Whether to show the label text.
  final bool labelVisible;

  /// {@template legacy_item_build_template}
  /// Builds the legacy item with animated icon and optional label.
  ///
  /// Uses AnimatedSwitcher for icon transitions and AnimatedDefaultTextStyle
  /// for label color changes when visible.
  ///
  /// Parameters:
  /// - [context]: The build context.
  ///
  /// Returns:
  /// A column widget with the icon and conditionally the label.
  /// {@endtemplate}
  @override
  Widget build(BuildContext context) {
    final color = isSelected ? active : inactive;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconTheme.merge(
          data: IconThemeData(color: color),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isSelected ? item.activeIcon : item.icon,
          ),
        ),
        if (labelVisible) ...[
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(fontSize: 12, color: color),
            child: Text(item.label),
          ),
        ],
      ],
    );
  }
}

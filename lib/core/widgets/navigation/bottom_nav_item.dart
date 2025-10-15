import 'package:flutter/material.dart';

import 'navigation_types.dart';

/// {@template bottom_nav_item_template}
/// A concrete implementation of [INavigationItem] for bottom navigation items.
///
/// Represents a standard navigation item with an icon, active icon, label,
/// and optional indicator visibility flag. Used in legacy or simple navigation bars.
/// {@endtemplate}
class BottomNavItem implements INavigationItem {
  /// {@macro bottom_nav_item_template}
  ///
  /// Parameters:
  /// - [icon]: The widget to display as the icon when not selected.
  /// - [activeIcon]: The widget to display as the icon when selected.
  /// - [label]: The text label for the navigation item.
  /// - [showIndicator]: Whether to show an indicator for this item (default false).
  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.showIndicator = false,
  });

  /// {@macro bottom_nav_item_template}
  @override
  final Widget icon;

  /// {@macro bottom_nav_item_template}
  @override
  final Widget activeIcon;

  /// {@macro bottom_nav_item_template}
  @override
  final String label;

  /// Whether this item should show a visual indicator when selected.
  final bool showIndicator;

  /// {@template bottom_nav_item_build_template}
  /// Builds the navigation item widget based on selection state and colors.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [isSelected]: Whether this item is currently selected.
  /// - [activeColor]: Color to use when selected.
  /// - [inactiveColor]: Color to use when not selected.
  ///
  /// Returns:
  /// A column widget containing the icon and label with appropriate styling.
  /// {@endtemplate}
  @override
  Widget build(
    BuildContext context,
    bool isSelected,
    Color activeColor,
    Color inactiveColor,
  ) {
    final color = isSelected ? activeColor : inactiveColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconTheme.merge(
          data: IconThemeData(color: color),
          child: isSelected ? activeIcon : icon,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

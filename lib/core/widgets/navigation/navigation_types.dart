import 'package:flutter/material.dart';

/// {@template navigation_item_template}
/// An abstract interface for navigation items in the bottom navigation bar.
///
/// Defines the contract for building navigation items with selection state,
/// providing active and inactive colors, and supplying icons and labels.
/// {@endtemplate}
abstract class INavigationItem {
  /// {@macro navigation_item_template}
  ///
  /// Implementations should build a widget representing the navigation item,
  /// taking into account the selection state and color schemes.
  ///
  /// Parameters:
  /// - [context]: The build context for the widget.
  /// - [isSelected]: Whether this item is currently selected.
  /// - [activeColor]: The color to use when the item is selected.
  /// - [inactiveColor]: The color to use when the item is not selected.
  ///
  /// Returns:
  /// A widget that represents the navigation item in the given state.
  Widget build(
    BuildContext context,
    bool isSelected,
    Color activeColor,
    Color inactiveColor,
  );

  /// The label text for this navigation item.
  String get label;

  /// The icon widget to display when the item is not selected.
  Widget get icon;

  /// The icon widget to display when the item is selected.
  Widget get activeIcon;
}

/// Defines the behavior for showing labels in the navigation bar.
enum CustomLabelBehavior { alwaysShow, alwaysHide, onlyShowSelected }

/// A callback function type for when a navigation destination is selected.
///
/// Parameters:
/// - [index]: The index of the selected destination.
typedef DestinationSelected = void Function(int index);

/// A builder function type for creating custom indicators in the navigation bar.
///
/// Parameters:
/// - [context]: The build context.
/// - [selectedIndex]: The currently selected item index.
/// - [previousIndex]: The previously selected item index.
/// - [itemCount]: Total number of items.
/// - [itemWidth]: Width of each item.
/// - [color]: The indicator color.
/// - [animation]: The animation controller for smooth transitions.
/// - [isRTL]: Whether the layout is right-to-left.
///
/// Returns:
/// A widget representing the custom indicator.
typedef IndicatorBuilder = Widget Function(
  BuildContext context, {
  required int selectedIndex,
  required int previousIndex,
  required int itemCount,
  required double itemWidth,
  required Color color,
  required Animation<double> animation,
  required bool isRTL,
});

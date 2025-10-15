import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'bottom_nav_item.dart';
import 'default_drop_indicator.dart';
import 'default_underline_indicator.dart';
import 'destination_semantics.dart';
import 'legacy_item.dart';
import 'navigation_types.dart';

/// {@template custom_navigation_bar_template}
/// A customizable bottom navigation bar with support for indicators, center items,
/// and flexible styling options.
///
/// Provides a modern navigation experience with optional animated indicators,
/// floating center items, and accessibility features.
/// {@endtemplate}
class CustomNavigationBar extends HookWidget {
  /// {@macro custom_navigation_bar_template}
  ///
  /// Parameters:
  /// - [items]: List of navigation items (INavigationItem or BottomNavItem).
  /// - [selectedIndex]: The currently selected item index.
  /// - [onDestinationSelected]: Callback when an item is selected.
  /// - [showDefaultIndicator]: Whether to show the default underline indicator.
  /// - [backgroundColor]: Background color of the navigation bar.
  /// - [activeColor]: Color for selected items.
  /// - [inactiveColor]: Color for unselected items.
  /// - [indicatorColor]: Color for the indicator.
  /// - [animationDuration]: Duration for indicator animations.
  /// - [labelBehavior]: How labels are displayed.
  /// - [elevation]: Shadow elevation.
  /// - [showDropWater]: Whether to use drop-style indicator.
  /// - [indicatorBuilder]: Custom indicator builder.
  /// - [height]: Custom height for the bar.
  /// - [itemHorizontalPadding]: Horizontal padding for items.
  /// - [centerItemIndex]: Index of item to float as center.
  /// - [centerItemSize]: Size of the floating center item.
  /// - [centerItemElevation]: Elevation of the center item.
  /// - [centerItemBackground]: Background color of center item.
  /// - [centerItemIconColor]: Icon color for center item.
  /// - [centerItemBottomOffset]: Bottom offset for center item.
  /// - [centerItemBorder]: Border for center item.
  /// - [centerItemOnTapOverride]: Custom tap handler for center item.
  const CustomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.showDefaultIndicator = false,
    // General colors
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    // Indicator
    this.indicatorColor,
    this.animationDuration = const Duration(milliseconds: 500),
    this.labelBehavior = CustomLabelBehavior.alwaysShow,
    this.elevation = 6,
    this.showDropWater = false,
    this.indicatorBuilder, // Custom indicator builder
    // Dimensions
    this.height,
    this.itemHorizontalPadding = 0,
    // Center item
    this.centerItemIndex, // Index to float as center
    this.centerItemSize = 56,
    this.centerItemElevation = 8,
    this.centerItemBackground,
    this.centerItemIconColor,
    this.centerItemBottomOffset = 18,
    this.centerItemBorder,
    this.centerItemOnTapOverride, // Override tap for center item
  })  : assert(
          items.length >= 2,
          'Navigation bar needs at least two destinations',
        ),
        assert(
          selectedIndex >= 0 && selectedIndex < items.length,
          'selectedIndex out of range',
        );

  /// List of navigation items.
  final List<dynamic> items; // INavigationItem or BottomNavItem

  /// The index of the currently selected item.
  final int selectedIndex;

  /// Callback invoked when a destination is selected.
  final DestinationSelected onDestinationSelected;

  // General colors
  /// Background color of the navigation bar.
  final Color? backgroundColor;

  /// Color for active/selected items.
  final Color? activeColor;

  /// Color for inactive/unselected items.
  final Color? inactiveColor;

  // Indicator
  /// Color for the navigation indicator.
  final Color? indicatorColor;

  /// Duration for animation transitions.
  final Duration animationDuration;

  /// Behavior for displaying item labels.
  final CustomLabelBehavior labelBehavior;

  /// Elevation (shadow) of the navigation bar.
  final double elevation;

  /// Whether to show the drop water indicator style.
  final bool showDropWater;

  /// Custom builder for the navigation indicator.
  final IndicatorBuilder? indicatorBuilder;

  // Dimensions
  /// Custom height for the navigation bar.
  final double? height;

  /// Horizontal padding applied to each item.
  final double itemHorizontalPadding;

  // Center item
  /// Index of the item to display as a floating center button.
  final int? centerItemIndex;

  /// Size of the floating center item.
  final double centerItemSize;

  /// Elevation of the center item.
  final double centerItemElevation;

  /// Background color of the center item.
  final Color? centerItemBackground;

  /// Icon color for the center item.
  final Color? centerItemIconColor;

  /// Bottom offset for positioning the center item.
  final double centerItemBottomOffset;

  /// Border decoration for the center item.
  final BoxBorder? centerItemBorder;

  /// Override tap handler for the center item.
  final VoidCallback? centerItemOnTapOverride;

  /// Whether to show the default indicator.
  final bool showDefaultIndicator;

  /// {@template custom_navigation_bar_build_template}
  /// Builds the custom navigation bar with indicators and floating center item.
  ///
  /// Handles animation, theming, and layout of navigation items with optional
  /// indicators and a special floating center item if specified.
  ///
  /// Parameters:
  /// - [context]: The build context.
  ///
  /// Returns:
  /// A Material widget containing the navigation bar layout.
  /// {@endtemplate}
  @override
  Widget build(BuildContext context) {
    final previousIndex = useRef<int>(selectedIndex);
    useEffect(
      () {
        previousIndex.value = selectedIndex;
        return null;
      },
      [selectedIndex],
    );

    final controller = useAnimationController(duration: animationDuration)
      ..forward(from: 0);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware color resolution
    final Color resolvedActive = activeColor ??
        (isDark ? theme.colorScheme.primary : theme.colorScheme.primary);
    final Color resolvedInactive = inactiveColor ??
        (isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
            : theme.colorScheme.onSurface.withValues(alpha: 0.6));
    final Color resolvedIndicator = indicatorColor ??
        (isDark ? theme.colorScheme.secondary : theme.colorScheme.secondary);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final double barHeight = height ?? (kBottomNavigationBarHeight + 24);
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final itemCount = items.length;
    final double itemWidth = deviceWidth / itemCount;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Bottom navigation',
      child: Material(
        color: Colors.transparent,
        elevation: elevation,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isDark ? theme.colorScheme.surface : Colors.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: barHeight,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Indicator (custom or default)
                  if (indicatorBuilder != null)
                    AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) => indicatorBuilder!.call(
                        context,
                        selectedIndex: selectedIndex,
                        previousIndex: previousIndex.value,
                        itemCount: itemCount,
                        itemWidth: itemWidth,
                        color: resolvedIndicator,
                        animation: controller,
                        isRTL: isRTL,
                      ),
                    )
                  else if (showDropWater)
                    DefaultDropIndicator(
                      controller: controller,
                      selectedIndex: selectedIndex,
                      previousIndex: previousIndex.value,
                      color: resolvedIndicator,
                      itemCount: itemCount,
                    )
                  else
                    DefaultUnderlineIndicator(
                      controller: controller,
                      selectedIndex: selectedIndex,
                      previousIndex: previousIndex.value,
                      color: resolvedIndicator,
                      itemCount: itemCount,
                      showDefaultIndicator: showDefaultIndicator,
                    ),

                  // Navigation items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(itemCount, (index) {
                      final item = items[index];
                      final bool isSelected = index == selectedIndex;
                      final bool isCenter = centerItemIndex == index;

                      bool labelVisible() {
                        switch (labelBehavior) {
                          case CustomLabelBehavior.alwaysShow:
                            return true;
                          case CustomLabelBehavior.alwaysHide:
                            return false;
                          case CustomLabelBehavior.onlyShowSelected:
                            return isSelected;
                        }
                      }

                      Widget child;
                      if (item is INavigationItem && item is! BottomNavItem) {
                        child = item.build(
                          context,
                          isSelected,
                          resolvedActive,
                          resolvedInactive,
                        );
                      } else if (item is BottomNavItem) {
                        child = LegacyItem(
                          item: item,
                          isSelected: isSelected,
                          active: resolvedActive,
                          inactive: resolvedInactive,
                          labelVisible: labelVisible(),
                        );
                      } else {
                        throw ArgumentError(
                          'Item at $index must implement INavigationItem.',
                        );
                      }

                      // Horizontal padding
                      child = Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: itemHorizontalPadding,
                        ),
                        child: child,
                      );

                      // For center item, hide the flat version
                      return Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => onDestinationSelected(index),
                          child: Opacity(
                            opacity: isCenter ? 0.0 : 1.0,
                            child: DestinationSemantics(
                              index: index,
                              total: itemCount,
                              selected: isSelected,
                              child: SizedBox(height: barHeight, child: child),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  // Floating center item
                  if (centerItemIndex != null &&
                      centerItemIndex! >= 0 &&
                      centerItemIndex! < itemCount)
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final idx = centerItemIndex!;
                          final left = (idx * itemWidth) +
                              (itemWidth / 2) -
                              (centerItemSize / 2);
                          final bool selectedCenter = selectedIndex == idx;

                          // Get icon from item
                          Widget? iconWidget;
                          final item = items[idx];
                          if (item is BottomNavItem) {
                            iconWidget =
                                selectedCenter ? item.activeIcon : item.icon;
                          } else if (item is INavigationItem) {
                            iconWidget =
                                selectedCenter ? item.activeIcon : item.icon;
                          }

                          return Stack(
                            children: [
                              Positioned(
                                left: left,
                                bottom: centerItemBottomOffset,
                                child: Transform.translate(
                                  offset: Offset(0, -(centerItemSize * 0.4)),
                                  child: SizedBox(
                                    width: centerItemSize,
                                    height: centerItemSize,
                                    child: FloatingActionButton(
                                      heroTag: 'bottom_nav_center_fab',
                                      elevation: centerItemElevation,
                                      backgroundColor: centerItemBackground ??
                                          (selectedCenter
                                              ? resolvedActive
                                              : (activeColor ??
                                                  resolvedActive)),
                                      foregroundColor: centerItemIconColor ??
                                          (isDark
                                              ? Colors.white
                                              : Colors.white),
                                      shape: const CircleBorder(),
                                      onPressed: centerItemOnTapOverride ??
                                          () => onDestinationSelected(idx),
                                      child: IconTheme.merge(
                                        data: const IconThemeData(size: 26),
                                        child: iconWidget ??
                                            const Icon(Icons.circle),
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
            ),
          ),
        ),
      ),
    );
  }
}

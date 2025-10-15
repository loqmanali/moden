import 'package:flutter/material.dart';

/// {@template destination_semantics_template}
/// A wrapper widget that adds accessibility semantics to navigation destinations.
///
/// Enhances screen reader support by providing proper labeling and selection state
/// for navigation items in the bottom bar.
/// {@endtemplate}
class DestinationSemantics extends StatelessWidget {
  /// {@macro destination_semantics_template}
  ///
  /// Parameters:
  /// - [index]: The 1-based index of this destination.
  /// - [total]: Total number of destinations.
  /// - [selected]: Whether this destination is currently selected.
  /// - [child]: The child widget to wrap with semantics.
  const DestinationSemantics({
    super.key,
    required this.index,
    required this.total,
    required this.selected,
    required this.child,
  });

  /// The index of this destination (0-based internally).
  final int index;

  /// Total number of destinations.
  final int total;

  /// Whether this destination is selected.
  final bool selected;

  /// The child widget to enhance with semantics.
  final Widget child;

  /// {@template destination_semantics_build_template}
  /// Wraps the child with Semantics widget for accessibility.
  ///
  /// Uses MaterialLocalizations to provide appropriate tab labels
  /// and marks the selected state.
  ///
  /// Parameters:
  /// - [context]: The build context.
  ///
  /// Returns:
  /// A Semantics widget wrapping the child with accessibility information.
  /// {@endtemplate}
  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Semantics(
      selected: selected,
      label: localizations.tabLabel(tabIndex: index + 1, tabCount: total),
      child: child,
    );
  }
}

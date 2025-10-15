import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A responsive spacing widget that adds gaps in your layout.
///
/// - Use [AppSpacing.height] for vertical space.
/// - Use [AppSpacing.width] for horizontal space.
/// - Use [AppSpacing.flex] for flexible space like [Spacer].
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Top'),
///     const AppSpacing.height(16),   // fixed vertical space
///     const AppSpacing.flex(1), // fills remaining space
///     Text('Bottom'),
///   ],
/// )
/// ```
class AppSpacing extends StatelessWidget {
  final double? size;
  final Axis axis;
  final int? flex;

  /// Creates a vertical or horizontal fixed spacing.
  const AppSpacing({
    super.key,
    required this.size,
    this.axis = Axis.vertical,
  }) : flex = null;

  /// Creates a vertical spacing with responsive height.
  const AppSpacing.height(double height, {Key? key})
      : this(size: height, axis: Axis.vertical, key: key);

  /// Creates a horizontal spacing with responsive width.
  const AppSpacing.width(double width, {Key? key})
      : this(size: width, axis: Axis.horizontal, key: key);

  /// Creates a flexible spacing (works like Spacer).
  const AppSpacing.flex(this.flex, {super.key})
      : size = null,
        axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    if (flex != null) {
      return Expanded(flex: flex!, child: const SizedBox.shrink());
    }
    return axis == Axis.vertical
        ? SizedBox(height: size!.h)
        : SizedBox(width: size!.w);
  }

  /// Predefined constants for common gaps (performance optimized).
  static const small = AppSpacing.height(8);
  static const medium = AppSpacing.height(16);
  static const large = AppSpacing.height(24);
}

///
extension AppSpacingExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

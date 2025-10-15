import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'adaptive_loading.dart';

/// ---------------------------------------------------------------------------
/// AdaptiveButton (Material 3 names from official docs)
/// ---------------------------------------------------------------------------
/// - Uses **Filled / Filled Tonal / Outlined / Text / Icon** naming per Flutter
///   API & Material 3. See: FilledButton, FilledButton.tonal, OutlinedButton,
///   TextButton, IconButton.
/// ---------------------------------------------------------------------------

class AdaptiveButton extends StatefulWidget {
  const AdaptiveButton({
    super.key,
    this.label,

    // NEW preferred props (Material 3 naming)
    this.variant,
    this.width,
    this.icon,
    this.iconSlot,
    this.size = AdaptiveButtonSize.medium,
    this.customPadding,
    this.isLoading = false,
    this.isDisabled = false,
    this.onPressed,
    this.onLongPress,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.labelFontSize,
    this.disabledColor,
    this.semanticLabel,
    this.tooltip,
    this.enableHapticFeedback = false,
    this.animationDuration = const Duration(milliseconds: 120),
    this.loadingIndicatorType = LoadingIndicatorType.fadingCircle,
    this.autoFocus = false,
    this.loadingIndicatorColor,
    this.focusNode,

    // NEW: fully custom size spec (overrides `size` enum if provided)
    this.sizeSpec,
  }) : assert(
          (variant == AdaptiveButtonVariant.icon)
              ? icon != null
              : label != null,
          'Icon is required for icon variant; label is required for other variants.',
        );

  final String? label;

  // NEW preferred props (Material 3 naming)
  final AdaptiveButtonVariant? variant;
  final ButtonWidthBehavior? width;
  final Widget? icon;
  final IconSlot? iconSlot;
  final AdaptiveButtonSize size;

  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final double? borderRadius;
  final double? labelFontSize;
  final Color? disabledColor;
  final EdgeInsets? customPadding;
  final LoadingIndicatorType loadingIndicatorType;
  final Color? loadingIndicatorColor;
  final String? semanticLabel;
  final String? tooltip;
  final bool enableHapticFeedback;
  final Duration animationDuration;
  final bool autoFocus;
  final FocusNode? focusNode;

  /// NEW: If provided, overrides the enum-based sizing without breaking old API.
  final ButtonSizeSpec? sizeSpec;

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton> {
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  AdaptiveButtonVariant get _variant {
    // variant is now required for AdaptiveButtonVariant.icon, otherwise defaults to filled
    if (widget.variant != null) return widget.variant!;
    return AdaptiveButtonVariant.filled;
  }

  ButtonWidthBehavior get _widthBehavior {
    if (widget.width != null) return widget.width!;
    return ButtonWidthBehavior.expanded; // Default to expanded
  }

  IconSlot? get _iconSlotOrNull {
    return widget.iconSlot;
  }

  AdaptiveButtonSize get _effectiveSize {
    return widget.size;
  }

  void _handlePress() {
    if (widget.isDisabled || widget.isLoading) return;
    if (widget.enableHapticFeedback) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.fuchsia:
          HapticFeedback.lightImpact();
          break;
        default:
          break;
      }
    }

    widget.onPressed?.call();
  }

  void _handleLongPress() {
    if (widget.isDisabled || widget.isLoading) return;
    if (widget.enableHapticFeedback) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.fuchsia:
          HapticFeedback.mediumImpact();
          break;
        default:
          break;
      }
    }
    widget.onLongPress?.call();
  }

  _ButtonSizeConfig get _sizeConfig {
    // NEW: Use custom spec first if provided (no breaking change).
    final custom = widget.sizeSpec;
    if (custom != null) {
      return _ButtonSizeConfig(
        height: custom.height,
        fontSize: custom.fontSize,
        fontWeight: custom.fontWeight,
        padding: custom.padding,
      );
    }

    // Otherwise keep the original enum-driven behavior intact.
    switch (_effectiveSize) {
      case AdaptiveButtonSize.large:
        return const _ButtonSizeConfig(
          height: 56.0,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        );
      case AdaptiveButtonSize.medium:
        return const _ButtonSizeConfig(
          height: 47.0,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        );
      case AdaptiveButtonSize.small:
        return const _ButtonSizeConfig(
          height: 32.0,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        );
    }
  }

  _ButtonTypeConfig get _typeConfig {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    switch (_variant) {
      case AdaptiveButtonVariant.filled:
        return _ButtonTypeConfig(
          backgroundColor: widget.backgroundColor ?? scheme.primary,
          labelColor: widget.labelColor ?? scheme.onPrimary,
          overlayColor: scheme.onPrimary.withValues(alpha: 0.08),
          borderSide: BorderSide.none,
        );
      case AdaptiveButtonVariant.tonal:
        return _ButtonTypeConfig(
          backgroundColor: widget.backgroundColor ?? scheme.secondaryContainer,
          labelColor: widget.labelColor ?? scheme.onSecondaryContainer,
          overlayColor: scheme.onSecondaryContainer.withValues(alpha: 0.10),
          borderSide: BorderSide.none,
        );
      case AdaptiveButtonVariant.outlined:
        return _ButtonTypeConfig(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          labelColor: widget.labelColor ?? scheme.primary,
          overlayColor: scheme.primary.withValues(alpha: 0.06),
          borderSide: BorderSide(color: widget.borderColor ?? scheme.primary),
        );
      case AdaptiveButtonVariant.text:
        return _ButtonTypeConfig(
          backgroundColor: Colors.transparent,
          labelColor: widget.labelColor ?? scheme.primary,
          overlayColor: scheme.primary.withValues(alpha: 0.06),
          borderSide: BorderSide.none,
        );
      case AdaptiveButtonVariant.icon:
        return _ButtonTypeConfig(
          backgroundColor: Colors.transparent,
          labelColor: widget.labelColor ?? scheme.primary,
          overlayColor: scheme.primary.withValues(alpha: 0.12),
          borderSide: BorderSide.none,
        );
    }
  }

  ButtonStyle get _buttonStyle {
    final size = _sizeConfig;
    final t = _typeConfig;

    final disabledFg =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);
    final disabledBg = widget.disabledColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
    final radius = widget.borderRadius ?? 12.0;

    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(
          _widthBehavior == ButtonWidthBehavior.expanded ? double.infinity : 0,
          size.height,
        ),
      ),
      padding: WidgetStateProperty.all(
        widget.customPadding ?? size.padding,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledBg;
        return t.backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledFg;
        return t.labelColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return t.overlayColor;
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (_variant == AdaptiveButtonVariant.outlined) {
          final disabledSide = BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.38),
          );
          return states.contains(WidgetState.disabled)
              ? disabledSide
              : t.borderSide;
        }
        return t.borderSide;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        final base = (widget.elevation ?? 0).toDouble();
        if (_variant == AdaptiveButtonVariant.filled) {
          if (states.contains(WidgetState.disabled)) return 0;
          if (states.contains(WidgetState.pressed)) return base + 1;
          return base;
        }
        return 0;
      }),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: widget.labelFontSize ?? size.fontSize,
          fontWeight: size.fontWeight,
        ),
      ),
      alignment: Alignment.center,
    );
  }

  Widget get _content {
    if (widget.isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: LoadingIndicator(
          type: widget.loadingIndicatorType,
          size: 22,
          strokeWidth: 2,
          color: widget.loadingIndicatorColor ?? _typeConfig.labelColor,
        ),
      );
    }

    if (_variant == AdaptiveButtonVariant.icon && widget.icon != null) {
      return widget.icon!;
    }

    return _buildLabelWithIcon();
  }

  Widget _buildLabelWithIcon() {
    final textStyle = TextStyle(
      color: widget.labelColor ?? _typeConfig.labelColor,
      fontSize: widget.labelFontSize ?? _sizeConfig.fontSize,
      fontWeight: _sizeConfig.fontWeight,
    );

    if (widget.icon == null) {
      return Text(widget.label!, style: textStyle);
    }

    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final slot =
        _iconSlotOrNull ?? (isRTL ? IconSlot.trailing : IconSlot.leading);

    return Row(
      mainAxisSize: _widthBehavior == ButtonWidthBehavior.expanded
          ? MainAxisSize.max
          : MainAxisSize.min,
      mainAxisAlignment: _widthBehavior == ButtonWidthBehavior.expanded
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (slot == IconSlot.leading) ...[
          widget.icon!,
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(widget.label!, style: textStyle)),
        if (slot == IconSlot.trailing) ...[
          const SizedBox(width: 8),
          widget.icon!,
        ],
      ],
    );
  }

  Widget get _buttonWidget {
    switch (_variant) {
      case AdaptiveButtonVariant.filled:
      case AdaptiveButtonVariant.tonal:
        return ElevatedButton(
          onPressed: widget.isDisabled ? null : _handlePress,
          onLongPress: widget.isDisabled || widget.onLongPress == null
              ? null
              : _handleLongPress,
          style: _buttonStyle,
          focusNode: _effectiveFocusNode,
          autofocus: widget.autoFocus,
          child: _content,
        );
      case AdaptiveButtonVariant.outlined:
        return OutlinedButton(
          onPressed: widget.isDisabled ? null : _handlePress,
          onLongPress: widget.isDisabled || widget.onLongPress == null
              ? null
              : _handleLongPress,
          style: _buttonStyle,
          focusNode: _effectiveFocusNode,
          autofocus: widget.autoFocus,
          child: _content,
        );
      case AdaptiveButtonVariant.text:
        return TextButton(
          onPressed: widget.isDisabled ? null : _handlePress,
          onLongPress: widget.isDisabled || widget.onLongPress == null
              ? null
              : _handleLongPress,
          style: _buttonStyle,
          focusNode: _effectiveFocusNode,
          autofocus: widget.autoFocus,
          child: _content,
        );
      case AdaptiveButtonVariant.icon:
        return IconButton(
          onPressed: widget.isDisabled ? null : _handlePress,
          icon: _content,
          style: _buttonStyle,
          focusNode: _effectiveFocusNode,
          autofocus: widget.autoFocus,
          tooltip: widget.tooltip,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = _buttonWidget;

    if (widget.tooltip != null && _variant != AdaptiveButtonVariant.icon) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    if (widget.semanticLabel != null) {
      button = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: !widget.isDisabled && !widget.isLoading,
        child: button,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _sizeConfig.height),
      child: button,
    );
  }
}

class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.height,
    required this.fontSize,
    required this.fontWeight,
    required this.padding,
  });
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;
}

class _ButtonTypeConfig {
  const _ButtonTypeConfig({
    required this.backgroundColor,
    required this.labelColor,
    required this.overlayColor,
    required this.borderSide,
  });
  final Color backgroundColor;
  final Color labelColor;
  final Color overlayColor;
  final BorderSide borderSide;
}

/// ---------------------------------------------------------------------------
/// Public custom sizing spec (non-breaking)
/// ---------------------------------------------------------------------------

class ButtonSizeSpec {
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const ButtonSizeSpec({
    required this.height,
    required this.fontSize,
    required this.fontWeight,
    required this.padding,
  });

  /// Optional presets for convenience.
  static const compact = ButtonSizeSpec(
    height: 40,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  );

  static const comfy = ButtonSizeSpec(
    height: 52,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
  );
}

/// ---------------------------------------------------------------------------
/// Enums (NEW preferred)
/// ---------------------------------------------------------------------------

enum AdaptiveButtonVariant { filled, tonal, outlined, text, icon }

enum AdaptiveButtonSize { large, medium, small }

enum ButtonWidthBehavior { expanded, shrinkWrap }

enum IconSlot { leading, trailing }

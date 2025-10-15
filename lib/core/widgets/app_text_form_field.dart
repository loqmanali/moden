import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.keyName,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.borderColor = AppColors.borderColor,
    this.focusedBorderColor = const Color(0xFF104C65),
    this.textColor,
    this.hintColor,
    this.errorColor,
    this.fontSize = 14,
    this.hintFontSize = 12,
    this.borderRadius = 8,
    this.borderWidth = 1,
    this.focusedBorderWidth = 2,
    this.backgroundColor = Colors.transparent,
    this.inputFormatters,
    this.validator,
    this.onSaved,
    this.onTapOutside,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled,
    this.autofillHints,
    this.keyboardAppearance,
    this.autofocus = false,
    this.textAlignVertical,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.showCursor,
    this.magnifierConfiguration,
    this.minLines,
    this.expands = false,
    this.maxLengthEnforcement,
    this.buildCounter,
    this.decorationOverride,
    this.textStyle,
  }) : assert(
          controller == null || initialValue == null,
          'do not use initialValue with controller',
        );

  final String? keyName;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;

  final String? labelText;
  final String? hintText;
  final String? errorText;

  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;

  final EdgeInsets contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;

  final Color borderColor;
  final Color focusedBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? errorColor;

  final double fontSize;
  final double hintFontSize;
  final double borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;

  final Color backgroundColor;

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;

  final Function(PointerDownEvent)? onTapOutside;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final AutovalidateMode autovalidateMode;

  // === الإضافات الجديدة ===
  final bool? enabled;
  final Iterable<String>? autofillHints;
  final Brightness? keyboardAppearance;
  final bool autofocus;
  final TextAlignVertical? textAlignVertical;

  final Color? cursorColor;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final double cursorWidth;
  final bool? showCursor;
  final TextMagnifierConfiguration? magnifierConfiguration;

  final int? minLines;
  final bool expands;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final InputCounterWidgetBuilder? buildCounter;

  final InputDecoration? decorationOverride;

  final TextStyle? textStyle;

  InputDecoration _decoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;
    final resolvedTextColor = textColor ??
        inputDecorationTheme.labelStyle?.color ??
        colorScheme.onSurface;
    final resolvedHintColor = hintColor ??
        inputDecorationTheme.hintStyle?.color ??
        colorScheme.onSurfaceVariant;
    final resolvedErrorColor = errorColor ??
        inputDecorationTheme.errorStyle?.color ??
        theme.colorScheme.error;

    return InputDecoration(
      alignLabelWithHint: (maxLines ?? 1) > 1,
      filled: true,
      fillColor: backgroundColor,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: contentPadding,
      hintStyle: (inputDecorationTheme.hintStyle ?? theme.textTheme.bodySmall)
          ?.copyWith(fontSize: hintFontSize, color: resolvedHintColor),
      errorStyle: (inputDecorationTheme.errorStyle ?? theme.textTheme.bodySmall)
          ?.copyWith(fontSize: 12, color: resolvedErrorColor),
      labelStyle: (inputDecorationTheme.labelStyle ?? theme.textTheme.bodySmall)
          ?.copyWith(color: resolvedTextColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide:
            BorderSide(color: focusedBorderColor, width: focusedBorderWidth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decorationOverride ?? _decoration(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;

    final resolvedTextColor = textColor ??
        inputDecorationTheme.labelStyle?.color ??
        colorScheme.onSurface;
    final effectiveStyle = textStyle ??
        theme.textTheme.bodySmall
            ?.copyWith(fontSize: fontSize, color: resolvedTextColor);

    return TextFormField(
      key: keyName != null ? ValueKey(keyName) : null,
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      expands: expands,
      readOnly: readOnly,
      enabled: enabled,
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
      },
      onTap: onTap,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical ??
          ((maxLines ?? 1) > 1 ? TextAlignVertical.top : null),
      style: effectiveStyle,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      // الإضافات
      autofillHints: autofillHints,
      keyboardAppearance: keyboardAppearance ?? theme.brightness,
      autofocus: autofocus,
      cursorColor: cursorColor ?? colorScheme.primary,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth,
      showCursor: showCursor,
      magnifierConfiguration: magnifierConfiguration,
      maxLengthEnforcement: maxLengthEnforcement,
      buildCounter: buildCounter,
      decoration: effectiveDecoration,
    );
  }
}

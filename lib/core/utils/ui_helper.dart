import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../design_system/app_colors/app_colors.dart';

/// {@template ui_helper}
/// A utility class that helps manage UI feedback mechanisms like bottom sheets, dialogs, snackbars, and toasts.
///
/// This class provides centralized methods to show various types of UI feedback to users
/// with consistent styling and behavior across the application.
/// {@endtemplate}
class UIHelper {
  /// Shows a modal bottom sheet with customizable content and behavior.
  ///
  /// Example usage:
  /// ```dart
  /// UIHelper.showBottomSheet(
  ///   context,
  ///   child: Container(
  ///     child: Text('Bottom Sheet Content'),
  ///   ),
  ///   bottomSheetType: BottomSheetType.scrollable,
  /// );
  /// ```
  ///
  /// **Parameters:**
  /// - `context`: The `BuildContext` in which the bottom sheet is displayed.
  /// - `child`: The content to be displayed inside the bottom sheet.
  /// - `bottomSheetType`: Defines the type of bottom sheet (scrollable or normal).
  /// - `isDismissible`: Determines if the bottom sheet can be dismissed by tapping outside.
  /// - `backgroundColor`: Custom background color for the bottom sheet.
  /// - `elevation`: Elevation for shadow effects of the bottom sheet.
  /// - `shape`: Custom shape for the bottom sheet.
  ///
  /// **Return Value:** Returns a `Future<T?>` containing the result from the bottom sheet.
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    BottomSheetType type = BottomSheetType.scrollable,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: type == BottomSheetType.scrollable,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      elevation: elevation,
      useSafeArea: true,
      shape: shape,
      showDragHandle: true,
      builder: (context) => child,
    );
  }

  /// Shows a dialog with a custom picker widget.
  ///
  /// Example usage:
  /// ```dart
  /// UIHelper.showDialogPicker(
  ///   context,
  ///   child: DatePickerWidget(),
  ///   barrierDismissible: true,
  /// );
  /// ```
  ///
  /// **Parameters:**
  /// - `context`: The `BuildContext` for the dialog.
  /// - `child`: The widget to be displayed inside the dialog.
  /// - `barrierDismissible`: Determines whether tapping outside the dialog will dismiss it.
  /// - `barrierColor`: Custom color for the dialog's background barrier.
  ///
  /// **Return Value:** Returns a `Future<T?>` containing the result from the dialog.
  static Future<T?> showDialogPicker<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    Color? backgroundColor,
    EdgeInsets? insetPadding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  /// Shows a snackbar with customizable style and behavior.
  ///
  /// Example usage:
  /// ```dart
  /// UIHelper.showSnackBar(
  ///   context,
  ///   message: 'Operation successful!',
  ///   type: SnackBarType.success,
  ///   duration: Duration(seconds: 3),
  ///   action: SnackBarAction(
  ///     label: 'Undo',
  ///     onPressed: () => print('Undo pressed'),
  ///   ),
  /// );
  /// ```
  ///
  /// **Parameters:**
  /// - `context`: The `BuildContext` in which the snackbar is shown.
  /// - `message`: The message text to be displayed in the snackbar.
  /// - `type`: Defines the type of snackbar (normal, success, error, warning).
  /// - `duration`: Duration for which the snackbar is shown.
  /// - `action`: The action button to show in the snackbar.
  /// - `elevation`: Elevation for the snackbar's shadow.
  /// - `margin`: Custom margin for the snackbar.
  /// - `padding`: Custom padding for the snackbar.
  /// - `behavior`: Defines the snackbar's behavior (floating, fixed).
  ///
  /// **Return Value:** Shows the snackbar without returning any value.
  static void showSnackBar(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.normal,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    final backgroundColor = switch (type) {
      SnackBarType.normal => AppColors.primary,
      SnackBarType.success => AppColors.green,
      SnackBarType.error => AppColors.red,
      SnackBarType.warning => AppColors.yellow,
    };

    final textColor = switch (type) {
      SnackBarType.normal => AppColors.primary,
      SnackBarType.success => AppColors.white,
      SnackBarType.error => AppColors.white,
      SnackBarType.warning => AppColors.white,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        elevation: elevation,
        margin: margin,
        padding: padding,
        behavior: behavior,
      ),
    );
  }

  static void showCustomSnackBar(
    BuildContext context, {
    String? title,
    String? description,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            title != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ],
                  )
                : Text(
                    'Success',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  /// Shows a toast notification with various customization options.
  ///
  /// Example usage:
  /// ```dart
  /// UIHelper.showToast(
  ///   title: 'Success',
  ///   description: 'Your operation was successful!',
  ///   duration: Duration(seconds: 4),
  ///   type: ToastificationType.success,
  /// );
  /// ```
  ///
  /// **Parameters:**
  /// - `title`: The title of the toast.
  /// - `description`: The description or message displayed in the toast.
  /// - `duration`: How long the toast should be visible.
  /// - `type`: Type of the toast (success, error, etc.).
  /// - `style`: Style of the toast (flat, rounded, etc.).
  /// - `alignment`: Alignment of the toast on the screen.
  /// - `applyBlurEffect`: Whether to apply a blur effect to the background.
  /// - `showProgressBar`: Whether to show a progress bar in the toast.
  /// - `closeOnClick`: Whether clicking the toast should close it.
  /// - `dragToClose`: Whether the toast can be closed by dragging.
  /// - `pauseOnHover`: Whether to pause the toast's closing when hovered.
  ///
  /// **Return Value:** Displays a toast notification without returning any value.
  static void showToast({
    String? title,
    String? description,
    Duration duration = const Duration(seconds: 2),
    ToastificationType? type,
    ToastificationStyle? style,
    Alignment? alignment,
    bool applyBlurEffect = false,
    bool showProgressBar = true,
    bool showIcon = false,
    bool closeOnClick = false,
    bool dragToClose = false,
    bool pauseOnHover = true,
    DismissDirection? dismissDirection,
    ui.TextDirection? direction,
    ProgressIndicatorThemeData? progressBarTheme =
        const ProgressIndicatorThemeData(
      linearTrackColor: Color(0xFFf4f4f4),
      circularTrackColor: Color(0xFF333333),
      linearMinHeight: 1,
    ),
    CloseButtonShowType? closeButtonShowType = CloseButtonShowType.none,
  }) {
    // Toastification().dismissAll();
    toastification.show(
      type: type ?? ToastificationType.success,
      style: style ?? ToastificationStyle.flatColored,
      title: title != null
          ? Text(
              title,
              style: TextStyle(color: AppColors.primary),
            )
          : null,
      description: description != null ? Text(description) : null,
      alignment: alignment,
      autoCloseDuration: duration,
      applyBlurEffect: applyBlurEffect,
      showProgressBar: showProgressBar,
      showIcon: showIcon,
      closeOnClick: closeOnClick,
      dragToClose: dragToClose,
      pauseOnHover: pauseOnHover,
      dismissDirection: dismissDirection,
      direction: direction,
      progressBarTheme: progressBarTheme,
      closeButtonShowType: closeButtonShowType,
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

/// Defines the behavior of bottom sheets
enum BottomSheetType {
  /// Regular bottom sheet with fixed height
  normal,

  /// Bottom sheet that can be scrolled if content exceeds screen height
  scrollable,
}

/// Defines the type of snackbar to display
enum SnackBarType {
  /// Default snackbar style
  normal,

  /// Success-themed snackbar (typically green)
  success,

  /// Error-themed snackbar (typically red)
  error,

  /// Warning-themed snackbar (typically yellow/orange)
  warning,
}

bool isRTL(String languageCode) => ['ar'].contains(languageCode);

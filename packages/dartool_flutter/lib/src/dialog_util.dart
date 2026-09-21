import 'package:flutter/material.dart';

/// Dialog / bottom-sheet helpers. All methods require a [BuildContext].
abstract final class DialogUtil {
  DialogUtil._();

  /// Show a standard [AlertDialog] and return its popped value.
  ///
  /// When [barrierDismissible] is `false`, the user must tap one of the
  /// [actions] to close the dialog.
  static Future<T?> alert<T>(
    BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) =>
        AlertDialog(title: title, content: content, actions: actions),
  );

  /// Show a confirm dialog with a cancel/confirm button.
  ///
  /// Returns `true` when the user taps [confirmText], `false` when tapping
  /// [cancelText] or the barrier.
  static Future<bool> confirm(
    BuildContext context, {
    Widget? title,
    Widget? content,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show a simple bottom sheet (material 3). Returns the popped value.
  static Future<T?> bottom<T>(
    BuildContext context,
    Widget Function(BuildContext context) builder, {
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    Color? backgroundColor,
    double? elevation,
  }) => showModalBottomSheet<T>(
    context: context,
    builder: builder,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor,
    elevation: elevation,
  );

  /// Close the topmost dialog or bottom sheet on [context]'s navigator.
  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop<T>(result);
    }
  }
}

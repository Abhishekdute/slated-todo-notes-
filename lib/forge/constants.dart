import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'app_strings.dart';
import '../../main.dart';

/// Empty Title & Subtite TextFields Warning
dynamic emptyFieldsWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: "Wait!",
    subMsg: "Please enter a title for your task.",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task Warning Dialog
dynamic warningNoTask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: "Empty List",
    message: "There are no tasks to delete.",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// Delete All Task Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStrings.deleteAllConfirm,
    message: "This action cannot be undone.",
    confirmButtonText: "Yes, Clear All",
    cancelButtonText: "Cancel",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () {
      BaseWidget.of(context).dataService.todoBox.clear();
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';

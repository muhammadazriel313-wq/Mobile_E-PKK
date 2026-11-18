import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shared UI and route behavior for multi-step report drafts.
class DraftStepHelper {
  const DraftStepHelper._();

  static Widget saveButton({
    required Future<bool> Function() onSave,
    String text = 'Simpan Draf',
  }) =>
      ButtonSecondaryOutline(text: text, onPressed: onSave);

  static Future<bool> saveAndReturn({
    required Future<bool> Function() save,
    required String homeRoute,
    required VoidCallback showSaved,
  }) async {
    if (!await save()) return false;
    Get.closeAllSnackbars();
    Get.until((route) => route.settings.name == homeRoute || route.isFirst);
    Future.delayed(const Duration(milliseconds: 150), showSaved);
    return true;
  }

  static Future<bool> confirmExit({
    required BuildContext context,
    required bool hasInput,
    required Future<bool> Function() saveAndReturn,
    required VoidCallback discard,
  }) async {
    if (!hasInput) return true;
    var savedViaDialog = false;
    final shouldExit = await DraftExitDialog.show(
      context: context,
      onSaveDraft: () async {
        savedViaDialog = await saveAndReturn();
        return savedViaDialog;
      },
    );
    if (savedViaDialog) return false;
    if (shouldExit) discard();
    return shouldExit;
  }
}

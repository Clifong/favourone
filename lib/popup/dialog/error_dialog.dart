
import 'package:favourone/popup/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: "An error has been encountered",
      content: text,
      optionBuilder: () => {
        'Ok': null
      }
  );
}
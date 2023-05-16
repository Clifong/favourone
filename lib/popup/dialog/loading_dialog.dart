
import 'package:flutter/material.dart';

Future<void> showLoadingDialog({required BuildContext context, required int timing}) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Loading"),
          content: CircularProgressIndicator(),
        );
      },
  );

  await Future.delayed(Duration(seconds: timing));

  Navigator.of(context).pop();
}
import 'package:flutter/material.dart';

Future showGenericSnackBar<T>({
  required BuildContext context,
  required String message,
}) async{
  final snackBar = SnackBar(
      content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(
      snackBar
  );
}
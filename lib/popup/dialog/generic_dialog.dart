import 'package:flutter/material.dart';

typedef optionsList<T>  = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required optionsList optionBuilder
})

{
  final options = optionBuilder();
  return showDialog
    (
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
              final T value = options[optionTitle];
              return TextButton(
                  onPressed: () {
                    if (value != null){
                      Navigator.of(context).pop(value);
                    }
                    else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(optionTitle)
              );
            }).toList(),
        );
      }
  );
}
import 'package:favourone/popup/dialog/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<bool?> showLogoutDialog(BuildContext context){
  return showGenericDialog<bool>(
      context: context,
      title: "Logout",
      content: "Are you sure you want to logout?",
      optionBuilder: () => {
        'Cancel': false,
        'Yes, logout': true,
      }
  );
}
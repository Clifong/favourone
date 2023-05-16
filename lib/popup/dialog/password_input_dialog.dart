import 'package:flutter/material.dart';

class PasswordPopupDialog extends StatefulWidget {
  final Map arguements;

  const PasswordPopupDialog({Key? key, required this.arguements}) : super(key: key);

  @override
  State<PasswordPopupDialog> createState() => _PasswordPopupDialogState();
}

class _PasswordPopupDialogState extends State<PasswordPopupDialog> {

  late TextEditingController passwordField;
  String text = "";

  @override
  void initState(){
    passwordField = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    passwordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height/4,
        width: MediaQuery.of(context).size.height/2,
        child: Column(
          children: [
            TextFormField(
              controller: passwordField,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: "Enter password",
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
              ),
            ),

            TextButton(
                onPressed: () {
                  if (passwordField.text == widget.arguements['password']){
                    Navigator.of(context).pop(true);
                  }
                  else {
                    setState((){
                      text = "Password incorrect, try again";
                    });
                  }
                },
                child: const Text("Enter")
            ),
          ],
        ),
      ),
    );
  }
}

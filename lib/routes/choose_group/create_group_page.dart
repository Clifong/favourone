import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import '../../cloud/getters_methods/cloud_user.dart';
import '../../popup/dialog/error_dialog.dart';
import '../../popup/dialog/generic_dialog.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late final TextEditingController _groupNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _doubleConfirmPasswordController;

  @override
  void initState(){
    _groupNameController = TextEditingController();
    _passwordController = TextEditingController();
    _doubleConfirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _groupNameController.dispose();
    _passwordController.dispose();
    _doubleConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _groupNameController,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text("Enter a group name"),
            hintText: "Group name",
            icon: Icon(Icons.group),
          ),
        ),

        TextFormField(
          controller: _passwordController,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text("Enter a password"),
            hintText: "Password",
            icon: Icon(Icons.password),
          ),
          validator: (value){
            return estimatePasswordStrength(value ?? "") < 0.5 ? "Password too weak" : "Strong password";
          },
        ),

        TextFormField(
          controller: _doubleConfirmPasswordController,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text("Re-enter a password"),
            hintText: "Password",
            icon: Icon(Icons.password),
          ),
        ),

        TextButton(onPressed: () async {
          if (_doubleConfirmPasswordController.text.isEmpty
              || _passwordController.text.isEmpty
              || _groupNameController.text.isEmpty){
            showErrorDialog(
                context,
                "Some fields are empty"
            );
          }
          else if (_doubleConfirmPasswordController.text != _passwordController.text){
            showErrorDialog(
                context,
                "Password not the same!"
            );
          }
          else if (estimatePasswordStrength(_passwordController.text) < 0.5){
            showGenericDialog(
                context: context,
                title: "Weak password",
                content:"Password is too weak! Try again",
                optionBuilder: () => {
                  'ok': null
                }
            );
          }
          else {
            final String ownerId = FirebaseAuthProvider().currentUser!.id;
            final creatorName = (await getCloudUser(userId: ownerId)).username;
            FirebaseCloudStorage().AddNewGroup(
                groupName: _groupNameController.text,
                password: _passwordController.text,
                ownerName: creatorName,
                ownerId: ownerId,
            );
            _groupNameController.clear();
            _passwordController.clear();
            _doubleConfirmPasswordController.clear();
          }
        },
            child: const Text("Enter")
        ),
      ],
    );
  }
}

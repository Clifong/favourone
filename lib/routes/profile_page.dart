import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/bloc/appbloc/app_event.dart';
import 'package:favourone/cloud/firebase_cloud_storage.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/appbloc/app_bloc.dart';
import '../popup/dialog/error_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final TextEditingController usernameController;

  @override
  void initState(){
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your profile"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: "enter your username",
              icon: Icon(Icons.person),
              labelText: "Your username:"
            ),
          ),

          TextButton(onPressed: () async {
            if (usernameController.text.isEmpty){
              showErrorDialog(context, "Username cannot be empty!");
            }
            else {
              final String newUsername = usernameController.text;
              final authUser = FirebaseAuthProvider().currentUser;
              final cloudUser = (await getCloudUser(userId: authUser!.id));
              await FirebaseCloudStorage().UpdateUserUsername(
                userId: authUser.id,
                username: newUsername,
                oldUsername: cloudUser.username,
              );
              context.read<AppBloc>().add(
                  AppEventGoMainPage(
                      username: newUsername
                  )
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text("Save")
          ),
        ],
      ),
    );
  }
}

import 'package:favourone/cloud/firebase_cloud_storage.dart';
import 'package:favourone/routes/route_string/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/appbloc/app_bloc.dart';
import '../bloc/appbloc/app_event.dart';
import '../bloc/appbloc/app_state.dart';
import '../enum/string_route.dart';
import '../popup/dialog/generic_dialog.dart';
import '../popup/dialog/login_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final FirebaseCloudStorage cloudStorage;

  @override
  void initState() {
    cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is AppStateMainPage) {
                return Text("Welcome ${state.username}");
              }
              return const Text("missing");
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(profile);
                },
                icon: const Icon(Icons.person)),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final value = await showLogoutDialog(context);
                  if (value == true) {
                    context.read<AppBloc>().add(const AppEventLogout());
                  }
                  break;
                case MenuAction.resetPassword:
                  final value = await showGenericDialog(
                      context: context,
                      title: "Reset password?",
                      content: "Do you want to reset password?",
                      optionBuilder: () => {
                            'No': false,
                            'Yes': true,
                          });
                  if (value == true) {
                    context.read<AppBloc>().add(const AppEventResetPassword());
                  }
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Logout")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.resetPassword,
                    child: Text("Reset password"))
              ];
            }),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      chooseGroup,
                  );
                },
                child: const Text('Attendance')),
            TextButton(onPressed: () {}, child: const Text('???')),
            TextButton(onPressed: () {}, child: const Text('???')),
            TextButton(onPressed: () {}, child: const Text('???')),
          ],
        ));
  }
}

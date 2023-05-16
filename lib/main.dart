import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/routes/route_string/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/appbloc/app_bloc.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final AppRoute _appRoute = AppRoute();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc(
        FirebaseAuthProvider(),
    ),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark(),
          onGenerateRoute: _appRoute.generateRoute
      ),
    );
  }
}









import '../../auth/triggers/auth_success.dart';

abstract class AppState{
  const AppState();
}

class AppStateDefault extends AppState{
  const AppStateDefault();
}

class AppStateRegisterPage extends AppState{
  final Exception? error;

  const AppStateRegisterPage({this.error});
}

class AppStateLoginPage extends AppState{
  final Exception? error;

  const AppStateLoginPage({this.error});
}

class AppStateMainPage extends AppState{
  final String? username;
  final Exception? error;
  final Success? success;

  AppStateMainPage({required this.username, required this.error, required this.success});
}

class AppStateVerifyEmailPage extends AppState{
  const AppStateVerifyEmailPage();
}








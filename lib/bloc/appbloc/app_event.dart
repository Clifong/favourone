import 'package:favourone/auth/auth_provider.dart';

abstract class AppEvent{
  const AppEvent();
}

class AppEventInitialize extends AppEvent{

  const AppEventInitialize();
}

class AppEventUserLogin extends AppEvent {
  final String email;
  final String password;
  final String providerName;

  const AppEventUserLogin({required this.email, required this.password, required this.providerName});
}

class AppEventUserRegister extends AppEvent{
  final String email;
  final String password;

  const AppEventUserRegister({required this.email, required this.password});
}

class AppEventLogout extends AppEvent{
  const AppEventLogout();
}

class AppEventSendEmailVerification extends AppEvent{
  const AppEventSendEmailVerification();
}

class AppEventResetPassword extends AppEvent{
  const AppEventResetPassword();
}

class AppEventGoMainPage extends AppEvent{
  final String username;

  AppEventGoMainPage({required this.username});
}

class AppEventGoRegisterPage extends AppEvent{
  const AppEventGoRegisterPage();
}

class AppEventGoLoginPage extends AppEvent{
  const AppEventGoLoginPage();
}





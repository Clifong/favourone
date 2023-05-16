import 'package:favourone/routes/register_page.dart';
import 'package:favourone/routes/verify_email_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/triggers/auth_exceptions.dart';
import '../auth/triggers/auth_success.dart';
import '../bloc/appbloc/app_bloc.dart';
import '../bloc/appbloc/app_event.dart';
import '../bloc/appbloc/app_state.dart';
import '../popup/dialog/generic_dialog.dart';
import '../popup/snackbar/showGenericSnackBar.dart';
import 'login_page.dart';
import 'main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    context.read<AppBloc>().add(const AppEventInitialize());

    return BlocConsumer<AppBloc, AppState>(listener: (context, state) {
      if (state is AppStateMainPage) {
        if (state.error is AuthResetPasswordError) {
          showGenericDialog(
              context: context,
              title: "Reset error",
              content: "Failed to send reset password email",
              optionBuilder: () => {'Okay': null});
        }
        if (state.success is ResetPasswordSuccess) {
          showGenericDialog(
              context: context,
              title: "Reset success",
              content: "Password reset email has been sent!",
              optionBuilder: () => {'Okay': null});
        }
        if (state.success is WelcomeBackSuccess) {
          showGenericSnackBar(context: context, message: "Welcome back!");
        }
        if (state.success is LoginSuccess) {
          showGenericSnackBar(
              context: context, message: "Login successful! Welcome!");
        }
      }
    }, builder: (context, state) {
      if (state is AppStateLoginPage) {
        return const LoginPage();
      } else if (state is AppStateRegisterPage) {
        return const RegisterPage();
      } else if (state is AppStateVerifyEmailPage) {
        return const VerifyEmailPage();
      } else if (state is AppStateMainPage) {
        return const MainPage();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
    ;
  }
}

import 'package:favourone/auth/triggers/auth_exceptions.dart';
import 'package:favourone/bloc/appbloc/app_bloc.dart';
import 'package:favourone/bloc/appbloc/app_event.dart';
import 'package:favourone/popup/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import '../bloc/appbloc/app_state.dart';
import '../popup/dialog/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
        listener: (context, state) async {
          if (state is AppStateLoginPage) {
            if (state.error is AuthUserNotFoundError) {
              await showErrorDialog(context, "Email not correct");
            } else if (state.error is AuthWrongPasswordError) {
              await showErrorDialog(context, "Email or password not correct");
            } else if (state.error is GenericError) {
              await showErrorDialog(context, "Something went wrong");
            }
          }
        },

        child: Scaffold(
          appBar: AppBar(title: const Text("Login")),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      labelText: "Enter email",
                      icon: Icon(Icons.email),
                  ),
                ),

                TextFormField(
                  controller: passwordController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Password",
                      labelText: "Enter password",
                      icon: Icon(Icons.password),
                  ),
                ),

                TextButton(
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;
                      context
                          .read<AppBloc>()
                          .add(AppEventUserLogin(
                          email: email,
                          password: password,
                          providerName: "email"
                      )
                      );
                    },
                    child: const Text("Enter")),

                SignInButton(
                    Buttons.Google,
                    text: "Login with your gmail",
                    onPressed: () {
                      context.read<AppBloc>().add(const AppEventUserLogin(
                          email: '',
                          password: '',
                          providerName: "google"
                          )
                      );
                    }
                ),

                Flexible(
                  child: TextButton(
                      onPressed: () {
                        context.read<AppBloc>().add(const AppEventGoRegisterPage());
                      },
                      child: const Text("Go to register oage")),
                ),
              ],
            ),
          ),
        ));
  }
}

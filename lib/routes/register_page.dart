import 'package:favourone/auth/triggers/auth_exceptions.dart';
import 'package:favourone/bloc/appbloc/app_bloc.dart';
import 'package:favourone/bloc/appbloc/app_event.dart';
import 'package:favourone/bloc/appbloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../popup/dialog/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState(){
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) async{
        if (state is AppStateRegisterPage) {
          if (state.error is AuthWeakPasswordError) {
            await showErrorDialog(context, "Your password is too weak. Tru again.");
          }
          else if (state.error is AuthEmailALreadyInUseError) {
            await showErrorDialog(context, "This email has been used. Please try again.");
          }
          else if (state.error is GenericError){
            await showErrorDialog(context, "Something went wrong");
          }
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text("Register"),),
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
                    labelText: "Enter password:",
                    icon: Icon(Icons.password),
                ),
              ),

              TextButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AppBloc>().add(AppEventUserRegister(
                        email: email,
                        password: password,
                        )
                    );
              },
                  child: const Text('Enter')
              ),

              TextButton(
                  onPressed: () {
                    context.read<AppBloc>().add(const AppEventGoLoginPage());
                  },
                  child: const Text("Go login page")
              ),
            ],
          ),
        ),
      ),
    );
  }
}

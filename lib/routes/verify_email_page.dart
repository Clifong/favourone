import 'package:favourone/bloc/appbloc/app_bloc.dart';
import 'package:favourone/bloc/appbloc/app_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar
          (
            title: const Text('Verify your email'),
          ),
        body: Column(
          children: [
            const Text("A verification email has been sent. If you do not receive it, click send again."),
            
            TextButton(onPressed: () 
            {
              context.read<AppBloc>().add(const AppEventSendEmailVerification());
            }, 
                child: const Text("Send again")
            ),

            TextButton(onPressed: () {
              context.read<AppBloc>().add(const AppEventGoLoginPage());
            },
                child: const Text("Go back")
            ),
          ],
        ),
      );
  }
}

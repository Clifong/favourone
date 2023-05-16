import 'package:bloc/bloc.dart' show Bloc;
import 'package:favourone/auth/auth_provider.dart';
import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:favourone/auth/triggers/auth_success.dart';
import 'package:favourone/bloc/appbloc/app_event.dart';
import 'package:favourone/bloc/appbloc/app_state.dart';
import 'package:favourone/cloud/firebase_cloud_storage.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/user.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AuthProvider chosenProvider) : super(const AppStateDefault()) {
    on<AppEventInitialize>((event, emit) async {
      await chosenProvider.initialize();
      final authUser = chosenProvider.currentUser;
      if (authUser != null) {
        final cloudUser = await getCloudUser(userId: authUser.id);
        emit(AppStateMainPage(
          username: cloudUser.username,
          error: null,
          success: WelcomeBackSuccess(),
        ));
      } else {
        emit(const AppStateLoginPage());
      }
    });

    on<AppEventUserLogin>((event, emit) async {
      try {
        if (event.providerName == "google") {
          final _googleSignIn = GoogleSignIn();
          await _googleSignIn.signOut();
          final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            final UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            final user = userCredential.user;
            if (user != null) {
              final authUser = AuthUser(
                id: user.uid,
                email: user.email,
                isEmailVerified: user.emailVerified,
              );
              try {
                final cloudUser = await getCloudUser(userId: authUser.id);
                emit(AppStateMainPage(
                  username: cloudUser.username,
                  error: null,
                  success: LoginSuccess(),
                ));
              } catch (e) {
                FirebaseCloudStorage().AddNewUser(user: authUser);
                final cloudUser = await getCloudUser(userId: authUser.id);
                emit(AppStateMainPage(
                  username: cloudUser.username,
                  error: null,
                  success: LoginSuccess(),
                ));
              }
            }
          }
        } else if (event.providerName == "email") {
          final user = await FirebaseAuthProvider().login(email: event.email, password: event.password);
          if (user != null) {
            final authUser = AuthUser(
              id: user.id,
              email: user.email,
              isEmailVerified: user.isEmailVerified,
            );
            if (authUser.isEmailVerified == true) {
              final cloudUser = await getCloudUser(userId: authUser.id);
              emit(AppStateMainPage(
                username: cloudUser.username,
                error: null,
                success: LoginSuccess(),
              ));
            } else {
              emit(const AppStateVerifyEmailPage());
            }
          }
        }
      } on Exception catch (e) {
        emit(AppStateLoginPage(error: e));
      }
    });

    on<AppEventUserRegister>((event, emit) async {
      try {
        final email = event.email;
        final password = event.password;
        await chosenProvider.register(email: email, password: password);
        await chosenProvider.sendEmailVerification();
        final user = chosenProvider.currentUser!;
        FirebaseCloudStorage().AddNewUser(user: user);
        emit(const AppStateVerifyEmailPage());
      } on Exception catch (e) {
        emit(AppStateRegisterPage(error: e));
      }
    });

    on<AppEventLogout>((event, emit) async {
      emit(const AppStateLoginPage());
      await chosenProvider.logout();
    });

    on<AppEventSendEmailVerification>((event, emit) async {
      await chosenProvider.sendEmailVerification();
    });

    on<AppEventResetPassword>((event, emit) async {
      try {
        chosenProvider.resetPassword();
        final user = chosenProvider.currentUser!;
        final cloudUser = await getCloudUser(userId: user.id);
        emit(AppStateMainPage(
          username: cloudUser.username,
          error: null,
          success: ResetPasswordSuccess(),
        ));
      } on Exception catch (e) {
        final user = chosenProvider.currentUser!;
        final cloudUser = await getCloudUser(userId: user.id);
        emit(AppStateMainPage(
          username: cloudUser.username,
          error: e,
          success: null,
        ));
      }
    });

    on<AppEventGoLoginPage>((event, emit) {
      emit(const AppStateLoginPage());
    });

    on<AppEventGoRegisterPage>((event, emit) {
      emit(const AppStateRegisterPage());
    });

    on<AppEventGoMainPage>((event, emit) {
      emit(AppStateMainPage(
        username: event.username,
        error: null,
        success: null,
      ));
    });
  }
}

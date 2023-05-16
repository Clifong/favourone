import 'package:favourone/auth/triggers/auth_exceptions.dart';
import 'package:favourone/auth/auth_provider.dart';
import 'package:favourone/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider{

  @override
  AuthUser? get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
    }
    else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser?> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      return user;
    }
    on FirebaseAuthException catch (e){
      switch (e.code) {
        case "user-not-found":
          throw AuthUserNotFoundError();
        case "wrong-password":
          throw AuthWrongPasswordError();
        default:
          throw GenericError();
      }
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<AuthUser?> register({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = currentUser;
      return user;
    }
    on FirebaseAuthException catch(e){
      switch (e.code){
        case "weak-password":
          throw AuthWeakPasswordError();
        case "email-already-in-use":
          throw AuthEmailALreadyInUseError();
        default:
          throw GenericError();
      }
    }
  }

  @override
  Future<void> resetPassword() async {
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail!);
    }
    on Exception catch(e){
      throw AuthResetPasswordError();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      user.sendEmailVerification();
    }
  }
}
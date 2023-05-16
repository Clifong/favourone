import 'package:favourone/auth/user.dart';

abstract class AuthProvider {
  //Initialize the authenticator used
  Future<void> initialize();

  //Getting the current user
  AuthUser? get currentUser;

  //Login function
  Future<AuthUser?> login({required String email, required String password});

  //Register function
  Future<AuthUser?> register({required String email, required String password});

  //Logout function
  Future<void> logout();

  //Sending email verification function
  Future<void> sendEmailVerification();

  //Password reset function
  Future<void> resetPassword();
}
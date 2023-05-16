import 'package:favourone/auth/auth_provider.dart';
import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/auth/user.dart';

class AuthService implements AuthProvider{
  late final provider;

  factory AuthService.Firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser
  => provider.currentUser;

  @override
  Future<void> initialize()
  => provider.initialize();

  @override
  Future<AuthUser?> login({required String email, required String password})
  => provider.login(email: email, password: password);

  @override
  Future<void> logout()
  => provider.logout();

  @override
  Future<AuthUser?> register({required String email, required String password})
  => provider.register(email: email, password: password);

  @override
  Future<void> resetPassword()
  => provider.resetPassword();

  @override
  Future<void> sendEmailVerification()
  => provider.sendEmailVerification();


  //Constructor
  AuthService(this.provider);
}
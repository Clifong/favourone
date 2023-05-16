import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String? email;
  final bool? isEmailVerified;

  AuthUser
      ({
    required this.id,
    required this.email,
    required this.isEmailVerified,
      });

  factory AuthUser.fromFirebase(User user) => AuthUser(
      id: user.uid,
      isEmailVerified: user.emailVerified,
      email: user.email!,
  );
}
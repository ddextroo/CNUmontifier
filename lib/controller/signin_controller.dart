import 'package:cnumontifier/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController {
  final AuthService _authService = AuthService();

  Future<User?> signInWithGoogle() async {
    final UserCredential? userCredential =
        await _authService.signInWithGoogle();
    if (userCredential != null) {
      await _authService.userStore(userCredential.user);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

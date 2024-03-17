import 'package:cnumontifier/service/auth_service.dart';

class SignInController {
 final AuthService _authService = AuthService();

 Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
 }

 Future<void> signOut() async {
    await _authService.signOut();
 }
}

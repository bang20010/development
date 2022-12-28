import '../utility/firebase_ Authentication.dart';

Future signIn(String email, String password) async {
  await Authentication()
      .getAuthentication()
      .signInWithEmailAndPassword(email: email, password: password);
}

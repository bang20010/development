import '../utility/firebase_ Authentication.dart';

Future signIn(String email, String password) async {
  await Authentication()
      .getAuthentication()
      .signInWithEmailAndPassword(email: email, password: password)
      .then(
    (doc) {
      return {"result": true, "docid": doc};
    },
    onError: (e) {
      return {"result": false, "error": e};
    },
  );
}

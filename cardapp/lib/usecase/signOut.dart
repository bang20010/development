import '../utility/firebase_ Authentication.dart';

Future signOut() async {
  await Authentication().getAuthentication().signOut().then(
    (doc) {
      return {"result": true, "docid": doc};
    },
    onError: (e) {
      return {"result": false, "error": e};
    },
  );
}

import '../utility/firebase_ Authentication.dart';

Future signOut() async {
  await Authentication().getAuthentication().signOut();
}

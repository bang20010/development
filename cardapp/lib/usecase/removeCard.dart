import '../utility/firebase_Store.dart';

Future deleteCard(String User, String getDocumentName) async {
  final desertRef =
      FireStoreApp().getStorage().child("Cards/${User}/${getDocumentName}.jpg");
  if (getDocumentName.isNotEmpty) {
    await desertRef.delete().then(onError: (e) {
      return {"result": false, "error": e};
    }, (value) => {}).then(
      (value) => {
        FireStoreApp()
            .collection
            .doc(User)
            .collection("CardList")
            .doc(getDocumentName)
            .delete()
      },
    );
  }
}

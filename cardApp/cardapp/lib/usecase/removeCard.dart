import '../utility/firebase_Store.dart';

Future deleteCard(String User, String getDocumentName) async {
  final desertRef =
      FireStoreApp().getStorage().child("Cards/${User}/${getDocumentName}.jpg");
  if (getDocumentName.isNotEmpty) {
    await desertRef.delete().then((value) => {}).then(
          (value) => {
            FireStoreApp()
                .getCardCollection()
                .doc(User)
                .collection("CardList")
                .doc(getDocumentName)
                .delete()
          },
        );
  }
}

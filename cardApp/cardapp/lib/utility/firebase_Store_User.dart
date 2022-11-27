import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FireStoreApp_User {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("User");
  final CollectionReference userPhoneCollection =
      FirebaseFirestore.instance.collection("UserPhoneNum");
  final storageRef = FirebaseStorage.instance.ref();

  getUserCollect() {
    return userCollection;
  }
}

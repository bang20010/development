import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreApp {
  // get firestore document data
  final CollectionReference collection =
      FirebaseFirestore.instance.collection("CardData");
        final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("CardData");
  final storageRef = FirebaseStorage.instance.ref();
  
  getCardCollection(){
   return collection;
  }
  getStorage(){
    return storageRef;
  }
  getUserColloection(){
    return userCollection;
  }
}

import 'package:cardapp/utility/firebase_Store.dart';
import 'package:flutter/material.dart';

import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store_User.dart';

Future searchUserEmail(String phonenumber) async {
  await FireStoreApp().getUserColloection().get().then((snapshot) {
    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (doc.id == phonenumber) {
        return data["email"];
      }
    });
  });
}
  // .then(
  //   (providers) {
  //     if (providers.length == 0) {
  //       return {"result": true};
  //     }
  //   },
  //   onError: (e) {
  //     return {"result": false, "error": e};
  //   },
  // );
  
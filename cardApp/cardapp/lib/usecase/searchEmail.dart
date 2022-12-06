import 'package:cardapp/utility/firebase_Store.dart';
import 'package:flutter/material.dart';

import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store_User.dart';

Future<String> searchUserEmail(String phonenumber) async {
  String rtnValue = "";
  await FireStoreApp().getUserColloection().get().then((snapshot) {
    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (doc.id == phonenumber) {
          rtnValue = data["email"];
          return false;
      }
    });
  });
  return rtnValue;
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
  
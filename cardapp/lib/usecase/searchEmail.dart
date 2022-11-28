import 'package:flutter/material.dart';

import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store_User.dart';

Future searchUserEmail(String email) async {
  await Authentication().getAuthentication().fetchProvidersForEmail(email).then(
    (providers) {
      if (providers.length == 0) {
        return {"result": true};
      }
    },
    onError: (e) {
      return {"result": false, "error": e};
    },
  );
}

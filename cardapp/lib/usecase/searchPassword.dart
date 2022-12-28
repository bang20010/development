import 'package:flutter/material.dart';

import '../utility/firebase_ Authentication.dart';

Future SearchPassword(String email) async {
  await Authentication()
      .getAuthentication()
      .sendPasswordResetEmail(email: email);
}

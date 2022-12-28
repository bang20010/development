import 'package:flutter/material.dart';

import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store_User.dart';

Future searchUserEmail(String email) async {
  await Authentication().getAuthentication().fetchProvidersForEmail(email);
}

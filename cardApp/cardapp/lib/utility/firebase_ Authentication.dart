import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardapp/screen/mainPage.dart';
import 'package:flutter/material.dart';
import '../screen/signinPage.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getAuthentication() {
    return auth;
  }
}

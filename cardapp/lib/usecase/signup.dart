import 'package:cardapp/usecase/checkEmail.dart';
import 'package:flutter/cupertino.dart';
import '../model/user.dart';
import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store_User.dart';

Future signUp(
    String email, String password, String phoneNum, String createDate) async {
  await Authentication()
      .getAuthentication()
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((doc) {
    addUserData(email, password, phoneNum, createDate);
  });
}

Future addUserData(
    String email, String password, String phoneNum, String createDate) async {
  return await FireStoreApp_User()
      .getUserCollect()
      .doc(email)
      .collection("Data")
      .doc(phoneNum)
      .set(User(
              email: email,
              phoneNum: phoneNum,
              password: password,
              createDate: createDate)
          .toJson())
      .then(onError: (e) {
    return false;
  });
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/busCard.dart';
import '../utility/firebase_Store.dart';

Future updateCardData(
  BuildContext context,
  String User,
  String path,
  String name,
  String companyName,
  String position,
  String phoneNum,
  String email,
  String homePage,
  String address,
  String companyCallNum,
  String createEndDate,
  String createDateEndSecond,
  String document,
) async {
  if (document != "") {
    if (homePage.isEmpty) {
      homePage = "없음";
    }
    File file = File(path);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // firebase에 사진 저장
    final ref = FireStoreApp()
        .getStorage()
        .child("Cards/${User}/${document}.jpg")
        .putFile(file, metadata);

    String url = await FireStoreApp()
        .getStorage()
        .child("Cards/${User}/${document}.jpg")
        .getDownloadURL();

    return await FireStoreApp()
        .getCardCollection()
        .doc(User)
        .collection("CardList")
        .doc(document)
        .update(busCard(
                name: name,
                companyName: companyName,
                phoneNum: phoneNum,
                email: email,
                position: position,
                address: address,
                companyCallNum: companyCallNum,
                createDate: createDateEndSecond,
                homePage: homePage,
                url: url)
            .toJson());
  }
  //     .then(
  //   (doc) {

  //   },
  //   onError: (e) {
  //     errorDialog(context, "${e} 에러가 발생했습니다.");
  //   },
  // );
}

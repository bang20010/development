

import 'dart:io';

import 'package:cardapp/utility/firebase_Store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/busCard.dart';

Future addCardData(
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
    String document
    ) async {
  
    if (homePage.isEmpty) {
      homePage = "없음";
    }
    File file = File(path);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // firebase에 사진 저장
    final ref = FireStoreApp()
        .getStorage()
        .child("Cards")
        .child("/${User}")
        .child("/${document}.jpg")
        .putFile(file, metadata);

    String url = await FireStoreApp().getStorage()
        .child("Cards")
        .child("/${User}")
        .child("/${document}.jpg")
        .getDownloadURL();

    if (url.isNotEmpty) {
      return await FireStoreApp()
          .getCardCollection()
          .doc(User)
          .collection("CardList")
          .doc(document)
          .set(busCard(
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
      //     .then(
      //   (doc) {
      //     return {"result": true, "docid": doc};
      //   },
      //   onError: (e) {
      //     return {"result": false, "error": e};
      //   },
      // );
  }
}

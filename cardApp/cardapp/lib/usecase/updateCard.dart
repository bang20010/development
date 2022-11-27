import 'dart:io';

import 'package:cardapp/model/busCard.dart';
import 'package:cardapp/screen/addCardPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
    bool isURLpic
    ) async {
  if (document != "") {
    if (homePage.isEmpty) {
      homePage = "없음";
    }
    if(!isURLpic){
    File file = File(path);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // firebase에 사진 저장
    final ref = storageRef
        .child("Cards/${User}/${document}.jpg")
        .putFile(file, metadata);

    String url = await storageRef
        .child("Cards/${User}/${document}.jpg")
        .getDownloadURL();
    }
      return await FireStoreApp()
          .getCollection()
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
                    url: path,
                    document: document)
                .toJson())
          .then(
        (doc) {
          return {"result": true, "docid": doc};
        },
        onError: (e) {
          return {"result": false, "error": e};
        },
      );
    }
  }


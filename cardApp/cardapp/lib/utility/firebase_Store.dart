import 'dart:io';
import 'package:cardapp/screen/updateCardPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:image_picker/image_picker.dart';
import '../screen/mainPage.dart';
import 'function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/busCard.dart';
import 'package:flutter/material.dart';

class FireStoreApp {
  // get firestore document data
  final CollectionReference collection =
      FirebaseFirestore.instance.collection("CardData");
  final storageRef = FirebaseStorage.instance.ref();

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
      String document) async {
    if (document != "") {
      if (homePage.isEmpty) {
        homePage = "없음";
      }
      File file = File(path);
      final metadata = SettableMetadata(contentType: "image/jpeg");
      // firebase에 사진 저장
      final ref = storageRef
          .child("Cards/${User}/${document}.jpg")
          .putFile(file, metadata);

      String url = await storageRef
          .child("Cards/${User}/${document}.jpg")
          .getDownloadURL();

      if (url.isNotEmpty) {
        return await collection
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
                    url: url,
                    document: document)
                .toJson())
            .then(
              (doc) =>
                  function().addDialog(context, "${companyName} 명함을 생성했습니다."),
              onError: (e) => function().errorDialog(
                  context, "${companyName} 명항을 생성에 실패했습니다. 정확한 값을 입력해주세요"),
            );
        ;
      } else {
        function().errorDialog(context, "명함에 사진을 불러올 수 없습니다.");
        return;
      }
    }
  }

  Future getUpdateCard(
      String User, String getDocumentName, BuildContext context) async {
    bool isUpdate = false;
    String path = "";

    await collection.doc(User).collection("CardList").get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc.id == getDocumentName) {
          isUpdate = true;
        }
      });
    });

    if (isUpdate) {
      var pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedFile) => path = pickedFile!.path);
      if (path != "") {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => updateCard(
              filename: path, documentName: getDocumentName, User: User),
        ));
      } else {
        function().errorDialog(context, "사진을 찾는데 실패했습니다. 다시 시도해주세요");
        return;
      }
    }
  }
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
//      bool isButtonActive
  ) async {
    if (document != "") {
      if (homePage.isEmpty) {
        homePage = "없음";
      }
      File file = File(path);
      final metadata = SettableMetadata(contentType: "image/jpeg");
      // firebase에 사진 저장
      final ref = storageRef
          .child("Cards/${User}/${document}.jpg")
          .putFile(file, metadata);

      String url = await storageRef
          .child("Cards/${User}/${document}.jpg")
          .getDownloadURL();

      if (url.isNotEmpty) {
        // isButtonActive = true;
        return await collection
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
                    url: url,
                    document: document)
                .toJson())
            .then(
              onError: (e) => print("Error updating document $e"),
              (doc) =>
                  function().addDialog(context, "${companyName} 명함을 수정했습니다."),
            )
            .then((value) => {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => mainPage(email: User)))
                });
      } else {
        function().errorDialog(context, "명함에 사진을 불러올 수 없습니다.");
        return;
      }
    }
  }

  Future deleteCard(
      BuildContext context, String User, String getDocumentName) async {
    final desertRef = storageRef.child("Cards/${User}/${getDocumentName}.jpg");
    if (getDocumentName.isNotEmpty) {
      function().addDialog(context, "명함을 삭제하시겠습니까?");
      await desertRef
          .delete()
          .then(
              onError: (e) => function().errorDialog(
                  context, "${e} 에러!! 데이터 베이스에 기존 사진이 삭제 되지 않았습니다. 다시 시도해 주세요"),
              (value) => {})
          .then((value) => {
                collection
                    .doc(User)
                    .collection("CardList")
                    .doc(getDocumentName)
                    .delete()
                    .then(
                      onError: (e) =>
                          function().errorDialog(context, "${e} 에러!! 명함을 삭제 할 수 없습니다."),
                      (doc) => {function().addDialog(context, "명함을 삭제했습니다.")},
                    )
              });
    }
  }
}

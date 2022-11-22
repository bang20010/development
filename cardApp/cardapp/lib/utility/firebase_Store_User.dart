import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../model/userPhoneNum.dart';
import 'function.dart';

class FireStoreApp_User {
    final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("User");
        final CollectionReference userPhoneCollection =
      FirebaseFirestore.instance.collection("UserPhoneNum");
  final storageRef = FirebaseStorage.instance.ref();

  Future addUserData(
      BuildContext context,
      String phoneNum,
      String email,
      String password,
      String createDate
      ) async {
      bool checkID = isCheckEmail(context, email);
      if (checkID) {
        return await userCollection.doc(email).set(User(
                email: email,
                phoneNum: phoneNum,
                password: password,
                createDate : createDate)
            .toJson()).then(
      (doc) => function().addDialog(context, ""),
      onError: (e) => function().errorDialog(context, "가입에 실패했습니다. 정확한 값을 입력해주세요"),
    );
      }else{
        return false;
      } 
    }
  

    bool isCheckEmail( BuildContext context, String email) {
      bool checkID = true;    
      userCollection.get().then((snapshot) {
      snapshot.docs.forEach((doc){
        print(doc);
        if (doc.id == email) {
          doc;
          doc.id;
          checkID = false;
        }
      });
    });
      if(checkID){
      return checkID;
      }
      else{
      function().errorDialog(context, "동일한 이메일이 있습니다");
      return checkID;
      }
    }

     bool isCheckPhoneNum( BuildContext context, String email) {
      bool checkID = true;    
      userPhoneCollection.get().then((snapshot) {
      snapshot.docs.forEach((doc){
        if (doc.id == email) {
          checkID = false;
        }
      });
    });
      if(checkID){
      return checkID;
      }
      else{
      function().errorDialog(context, "동일한 핸드폰 번호가 있습니다");
      return checkID;
      }
    }
    Future addUserPhoneNum(
      BuildContext context,
      String phoneNum,
      String email,
      String createDate
      ) async {
      bool checkID = isCheckPhoneNum(context, phoneNum);
      if (checkID) {
        return await userPhoneCollection.doc(phoneNum).set(UserPhoneNum(
                email: email,
                phoneNum: phoneNum,
                createDate : createDate)
            .toJson()).then(
      (doc) => function().addDialog(context, ""),
      onError: (e) => function().errorDialog(context, "가입에 실패했습니다. 정확한 값을 입력해주세요"),
    );
      }else{
        return false;
      } 
    }

     Future searchUserPhoneNum(
      BuildContext context,
      String phoneNum
      ) async {
        String rtnValue = "";

     userPhoneCollection.get().then((snapshot) {
      snapshot.docs.forEach((doc){
        if (doc.id == phoneNum) {
         rtnValue = doc["email"];
        }
      });
      if(rtnValue.isNotEmpty){
        function().addDialog(context, "고객님의 등록된 이메일은 ${rtnValue} 입니다.");
        return;
      }
      else{
        function().errorDialog(context, "해당되는 이메일이 없습니다.");
        return;
      }
    });
    }
      }
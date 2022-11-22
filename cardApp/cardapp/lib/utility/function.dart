import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';

class function {
  bool isEqualsValue(var value, var dbValue) {
    bool rtnValue = false;
    if (value == dbValue) {
      rtnValue = true;
    }
    return rtnValue;
  }

  bool isCheckFiveValue(String path, String companyName, String name,
      String position, String document) {
    bool rtnValue = false;
    if (path.isNotEmpty &&
        companyName.isNotEmpty &&
        name.isNotEmpty &&
        position.isNotEmpty &&
        document != "") {
      rtnValue = true;
    }
    return rtnValue;
  }
 bool CheckSignin(
      bool checkEmail,
      bool checkPassword
      ) {
        bool rtnValue = false;
  if(checkEmail && checkPassword ) {
      rtnValue = true;
      return rtnValue;
    }
    return rtnValue;
  }

   bool CheckSignup(
      bool checkEmail,
      bool checkPassword,
      bool checkPhoneNum
      ) {
        bool rtnValue = false;
  if(checkEmail && checkPassword && checkEmail) {
      rtnValue = true;
      return rtnValue;
    }
    return rtnValue;
  }

  bool CheckAddCardValue(
      bool checkCompanyName,
      bool checkPosition,
      bool checkPhoneNum,
      bool checkHomePage,
      bool checkEmail,
      bool checkAddress,
      bool checkCompanyNum
      ) {
        bool rtnValue = false;
    if (checkCompanyName &&
        checkPosition &&
        checkPhoneNum &&
        checkHomePage &&
        checkEmail &&
        checkAddress &&
        checkCompanyNum) {
          rtnValue = true;
          return rtnValue;
    }
    return rtnValue;
  }



  String rtnDocument(String companyName, String name, String position) {
    String document = "";
    if (companyName.isNotEmpty && name.isNotEmpty && position.isNotEmpty) {
      document = "${companyName}_ ${name}_ ${position}";
    }
    return document;
  }

  String getNowTimeEndSecond() {
    DateTime now = DateTime.now(); // 저장하기 누르면 반환
    String formatDate = DateFormat('"yyyy-MM-dd HH:mm:ss').format(now);
    return formatDate;
  }

  String getNowTimeEndDate() {
    DateTime now = DateTime.now(); // 저장하기 누르면 반환
    String formatDate = DateFormat('"yyyy-MM-dd').format(now);
    return formatDate;
  }

  void popAddCard(final context, String filename) {
    filename = "";
    Navigator.pop(context);
  }

  void popbeforePage(final context) {
    Navigator.pop(context);
  }

  void addDialog(BuildContext context, String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${value}.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void errorDialog(BuildContext context, String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("에러"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${value}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

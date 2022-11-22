import 'package:cardapp/screen/searchPwPage.dart';
import 'package:cardapp/screen/signinPage.dart';
import 'package:cardapp/screen/signupPage.dart';
import 'package:cardapp/utility/firebase_Store_User.dart'; 
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../utility/function.dart';

class searchIdPage extends StatefulWidget {
  const searchIdPage({Key? key}) : super(key: key);
  @override
  searchIdPage_View createState() => searchIdPage_View();
}

final storageRef = FirebaseStorage.instance.ref();

class searchIdPage_View extends State<searchIdPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editColPhoneNum, _editColPassword;

  FocusNode _phoneFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColPhoneNum = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    String title = "이메일 찾기";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("${title}",
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            width: media_querysize.width,
            height: media_querysize.height + 250,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _showPhoneNumInput(),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          String phoneNum = _editColPhoneNum.text.trim();
                          FireStoreApp_User()
                              .searchUserPhoneNum(context, phoneNum);
                        },
                        child: Text('이메일 찾기'),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //회원가입 아이디, 비밀번호, 비밀번호 확인, 핸드폰 번호
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => searchPW(),
                    ));
                  },
                  child: Text('비밀번호 찾기'),
                ),
              ),

              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    function().popbeforePage(context);
                  },
                  child: Text('뒤로 가기'),
                ),
              ),
            ],
          ),
        ));
    throw UnimplementedError();
  }

  Widget _showPhoneNumInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColPhoneNum,
                  focusNode: _phoneFocus,
                  decoration: _textFormDecoration('핸드폰 번호'),
                  onSaved: (value) {
                    setState(() {
                      _editColPhoneNum.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$');
                    if (value!.isEmpty) {
                      return "핸드폰 번호가 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      return null;
                    } else {
                      return "핸드폰 번호를 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  InputDecoration _textFormDecoration(hintText) {
    return new InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0), hintText: hintText);
  }

  InputDecoration _texthelperDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
    );
  }
}

import 'package:cardapp/screen/signinPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../usecase/searchPassword.dart';
import '../utility/firebase_ Authentication.dart';


class searchPW extends StatefulWidget {
  const searchPW({Key? key}) : super(key: key);
  @override
  searchPW_View createState() => searchPW_View();
}

final storageRef = FirebaseStorage.instance.ref();

class searchPW_View extends State<searchPW> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editColEmail;

  FocusNode _emailFocus = new FocusNode();
  FocusNode _phoneFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColEmail = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    String title = "비밀번호 찾기";

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
                    _showEmailInput(),
                    searchPwButton(_editColEmail),
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
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 232, 232, 232),
                      onPrimary: Colors.black),
                  onPressed: () async{
                    String email = _editColEmail.text;
                    await SearchPassword( email).then((value){
                               value as Map;
                                if (value["result"] == true) {
                                  searchDialog(context,"해당 이메일로 메일을 보냈습니다");
                                }else if (value["result"] == false) {
                                  String error = value["error"];
                                  errorDialog(context, error);
                                }
                    });
                  },
                  child: Text('비밀번호 찾기'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 232, 232, 232),
                      onPrimary: Colors.black),
                  onPressed: () {
                    popbeforePage(context);
                  },
                  child: Text('뒤로가기'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 232, 232, 232),
                      onPrimary: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => signinPage(),
                    ));
                  },
                  child: Text('메인으로'),
                ),
              ),
            ],
          ),
        ));
    throw UnimplementedError();
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColEmail,
                  focusNode: _emailFocus,
                  decoration: _textFormDecoration('이메일'),
                  onSaved: (value) {
                    setState(() {
                      _editColEmail.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    if (value!.isEmpty) {
                      return "이메일이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      return null;
                    } else {
                      return "이메일을 정확히 입력해주세요.";
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
      });
}

void searchDialog(BuildContext context, String value) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => signinPage(),
                    ));
                  })
            ]);
      });
}
  void popbeforePage(final context) {
    Navigator.pop(context);
  }
  Widget searchPwButton(TextEditingController _editColEmail){
   return  SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 232, 232, 232),
                            onPrimary: Colors.black),
                        onPressed: () async{
                          String email = _editColEmail.text;
                          await SearchPassword(email).then((value) => {
                            
                          });
                        },
                        child: Text('비밀번호 찾기'),
                      ),
                    );
                    }
  
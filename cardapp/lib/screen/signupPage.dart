import 'package:cardapp/screen/searchPwPage.dart';
import 'package:cardapp/screen/signinPage.dart';
import 'package:cardapp/screen/termsOfService.dart';
import 'package:cardapp/usecase/getCurrentDate.dart';
import 'package:cardapp/utility/firebase_%20Authentication.dart';
import 'package:cardapp/utility/firebase_Store_User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../usecase/signup.dart';

class signupPage extends StatefulWidget {
  const signupPage({Key? key}) : super(key: key);
  @override
  signupPage_View createState() => signupPage_View();
}

final storageRef = FirebaseStorage.instance.ref();

class signupPage_View extends State<signupPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editColEmail,
      _editColPassword,
      _editColIsPassword,
      _editColPhoneNum,
      _editingColName,
      _editingColID;

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _isPasswordFocus = new FocusNode();
  FocusNode _phoneFocus = new FocusNode();
  FocusNode _nameFocus = new FocusNode();
  FocusNode _idFocus = new FocusNode();

  late bool isButtonActive;
  late bool _isChecked;

  bool checkEmail = false;
  bool checkPassword = false;
  bool checkPhoneNum = false;

  @override
  void initState() {
    isButtonActive = false;
    _isChecked = false;
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColEmail = TextEditingController();
    _editColPassword = TextEditingController();
    _editColIsPassword = TextEditingController();
    _editColPhoneNum = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    String title = "회원 가입";

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
                  _showPasswordInput(),
                  _showIsPasswordInput(),
                  _showPhoneNumInput(),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        GestureDetector(
                            child: Text("개인정보 활용에 동의하시겠습니까?",
                                style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    termsOfService(),
                              ));
                            })
                      ],
                    ),
                  ),
                  SizedBox(
                      width: media_querysize.width - 230,
                      height: media_querysize.height / 28,
                      child: ElevatedButton(
                        onPressed: isButtonActive
                            ? () async {
                                String email = _editColEmail.text.trim();
                                String password = _editColPassword.text.trim();
                                String isPassword =
                                    _editColIsPassword.text.trim();
                                String phoneNum = _editColPhoneNum.text.trim();
                                String createDate = getCurrentDate().trim();
                                if (_isChecked) {
                                  await signUp(
                                          email, password, phoneNum, createDate)
                                      .then((value) {
                                    signUpDialog(context, "회원가입을 완료했습니다");
                                  }, onError: (e) {
                                    errorDialog(context, "회원가입에 실패했습니다.");
                                  });
                                } else {
                                  errorDialog(context, "이용 약관을 체크해주세요.");
                                }
                              }
                            : null,
                        child: Text("${title}"),
                      )),
                ],
              )),
        ),
      ),
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       SizedBox(
      //         child: ElevatedButton(
      //           onPressed: () async {
      //             String email = _editColEmail.text.trim();
      //             String password = _editColPassword.text.trim();
      //             String isPassword = _editColIsPassword.text.trim();
      //             String phoneNum = _editColPhoneNum.text.trim();
      //             String createDate = getCurrentDate().trim();

      //             await signUp(email, password, phoneNum, createDate).then(
      //                 (value) {
      //               signUpDialog(context, "회원가입을 완료했습니다");
      //             }, onError: (e) {
      //               errorDialog(context, "회원가입에 실패했습니다.");
      //             });
      //           },
      //           child: Text("${title}"),
      //         ),
      //       ),
      //       //회원가입 아이디, 비밀번호, 비밀번호 확인, 핸드폰 번호
      //       SizedBox(
      //         child: ElevatedButton(
      //           onPressed: () {
      //             popbeforePage(context);
      //           },
      //           child: Text('뒤로 가기'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
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
                      checkEmail = true;
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

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _editColPassword,
                  focusNode: _passwordFocus,
                  inputFormatters: [],
                  decoration: _textFormPWDecoration('비밀번호'),
                  onSaved: (value) {
                    setState(() {
                      _editColPassword.text = value as String;
                    });
                  },
                  validator: (String? value) {
                    RegExp isValue = RegExp(r"^[a-zA-Zㄱ-ㅎ가-힣0-9]*$");
                    if (value!.isEmpty) {
                      return "비밀번호가 비어있습니다. [6글자 이상 입력해주세요]";
                    }
                    if (isValue.hasMatch(value) && value.length > 5) {
                      return null;
                    } else {
                      return "비밀번호를 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  Widget _showIsPasswordInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _editColIsPassword,
                  focusNode: _isPasswordFocus,
                  inputFormatters: [],
                  decoration: _textFormPWDecoration('비밀번호 확인'),
                  onSaved: (value) {
                    setState(() {
                      _editColIsPassword.text = value as String;
                    });
                  },
                  validator: (String? value) {
                    RegExp isValue = RegExp(r"^[A-Za-z\d@$!%*#?&]*$");
                    String password = _editColPassword.text.trim();
                    if (value!.isEmpty) {
                      return "비밀번호 확인이 비어있습니다.";
                    }
                    if (password == value) {
                      return null;
                      checkPassword = true;
                    } else {
                      return "비밀번호가 같지 않습니다.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
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
                      isButtonActive = true;
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

  InputDecoration _textFormPWDecoration(hintText) {
    return new InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        hintText: hintText,
        labelText: "Password");
  }

  InputDecoration _texthelperDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
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
        });
  }

  void signUpDialog(BuildContext context, String value) async {
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
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => signinPage()),
                      );
                    })
              ]);
        });
  }
}

void popbeforePage(final context) {
  Navigator.pop(context);
}
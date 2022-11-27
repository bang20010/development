import 'package:cardapp/screen/searchIdPage.dart';
import 'package:cardapp/screen/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../usecase/signin.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'mainPage.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly', // 반환값 확인
  ],
);

class signinPage extends StatefulWidget {
  const signinPage({Key? key}) : super(key: key);
  @override
  signinPage_View createState() => signinPage_View();
}

class signinPage_View extends State<signinPage> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  bool _isSigningIn = false;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editColEmail, _editColPassword;

  bool checkEmail = false;
  bool checkPassword = false;

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  late bool isButtonActive;

  @override
  void initState() {
    isButtonActive = false;
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColEmail = TextEditingController();
    _editColPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    String title = "로그인 페이지";
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
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        width: media_querysize.width,
        height: media_querysize.height + 250,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                _showEmailInput(),
                _showPasswordInput(),
                SizedBox(
                  height: media_querysize.height / 30,
                ),
                SizedBox(
                  width: media_querysize.width - 230,
                  height: media_querysize.height / 28,
                  child: SignInButton(
                    Buttons.Google,
                    text: "구글로 로그인 하기",
                    onPressed: () async {
                      setState(() {
                        _isSigningIn = true;
                      });
                      setState(() {
                        _isSigningIn = false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: media_querysize.height / 30,
                ),
                SizedBox(
                  width: media_querysize.width - 230,
                  height: media_querysize.height / 28,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.email),
                    style: ElevatedButton.styleFrom(
                      onSurface: Colors.blue,
                    ),
                    onPressed: isButtonActive
                        ? () async {
                            String email = _editColEmail.text.trim();
                            String password = _editColPassword.text.trim();
                            await signIn(email, password).then(
                              (value) {
                                value as Map;
                                if (value["result"] == true) {

                                  var userinfo = value["docid"] as UserCredential;
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          mainPage(
                                        email: userinfo.credential!.providerId,
                                      ),
                                    ),
                                  );
                                } else if (value["result"] == false) {
                                  String error = value["error"];
                                  errorDialog(context, error);
                                }
                              },
                            );
                          }
                        : null,
                    label: Text('이메일로 로그인'),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //회원가입 아이디, 비밀번호, 비밀번호 확인, 핸드폰 번호
          //핸드폰 번호로 아이디 찾기
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const searchIdPage(),
                ));
              },
              child: Text('아이디 찾기'),
            ),
          ),
          //아이디 찾은 후 이메일로 인증 받아서 확인
          SizedBox(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const signupPage(),
                ));
              },
              child: Text('회원가입'),
            ),
          ),
        ]),
      ),
    );
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
                      checkEmail = true;
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
                  decoration: _textFormDecoration('비밀번호'),
                  onSaved: (value) {
                    setState(() {
                      _editColPassword.text = value as String;
                    });
                  },
                  validator: (String? value) {
                    RegExp isValue = RegExp(r"^[a-zA-Zㄱ-ㅎ가-힣0-9]*$");
                    if (value!.isEmpty) {
                      return "비밀번호가 비어있습니다.";
                    }
                    if (isValue.hasMatch(value) && value.length > 5) {
                      checkPassword = true;
                      isButtonActive = true;
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

  bool CheckSignin(bool checkEmail, bool checkPassword) {
    bool rtnValue = false;
    if (checkEmail && checkPassword) {
      rtnValue = true;
      return rtnValue;
    }
    return rtnValue;
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

void signUpDialog(BuildContext context, String value, String email) async {
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
                      builder: (BuildContext context) => mainPage(
                        email: email,
                      ),
                    ));
                  })
            ]);
      });
}

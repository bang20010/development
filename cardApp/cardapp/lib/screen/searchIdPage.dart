import 'package:cardapp/screen/searchPwPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../usecase/searchEmail.dart';

class searchIdPage extends StatefulWidget {
  const searchIdPage({Key? key}) : super(key: key);
  @override
  searchIdPage_View createState() => searchIdPage_View();
}

class searchIdPage_View extends State<searchIdPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editColEmailNum, _editColPassword;

  FocusNode _phoneFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColEmailNum = TextEditingController();
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
        body: Center (
          child: SingleChildScrollView(
              child: SizedBox(
                  width: media_querysize.width,
                  height: media_querysize.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: _showPhoneNumInput(media_querysize),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: media_querysize.width - 234,
                        height: media_querysize.height / 28,
                        child: ElevatedButton(
                          onPressed: () {
                            String phnonenumber = _editColEmailNum.text.trim();
                            searchUserEmail(phnonenumber).then((value) {
                              value as String;
                              if (value.isNotEmpty) {
                                addDialog(context, "등록된 이메일은 ${value} 입니다.");
                              } else {
                                errorDialog(context, "회원가입한 이메일이없습니다");
                              }
                            }, onError: (e) {
                              errorDialog(context, "${e} 에러가 발생했습니다");
                            });
                          },
                          child: Text('이메일 찾기'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: media_querysize.width - 234,
                        height: media_querysize.height / 28,
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
                        height: 20,
                      ),
                    ],
                  ))),
        ),
        // bottomNavigationBar: Container(
        //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       //회원가입 아이디, 비밀번호, 비밀번호 확인, 핸드폰 번호
        //       SizedBox(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute<void>(
        //               builder: (BuildContext context) => searchPW(),
        //             ));
        //           },
        //           child: Text('비밀번호 찾기'),
        //         ),
        //       ),

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
        // )
        );
    throw UnimplementedError();
  }

  Widget _showPhoneNumInput(media_querysize) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
          child: TextFormField(
            controller: _editColEmailNum,
            focusNode: _phoneFocus,
            decoration: _textFormDecoration('핸드폰 번호'),
            onSaved: (value) {
              setState(() {
                _editColEmailNum.text = value as String;
              });
            },
            validator: (value) {
              RegExp isValue = RegExp("010-?([0-9]{4})-?([0-9]{4})");
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
    );
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

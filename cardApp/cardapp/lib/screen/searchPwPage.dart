import 'package:cardapp/screen/signinPage.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:flutter/material.dart';
import '../utility/function.dart';

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
                  _showEmailInput()
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            child: ElevatedButton.icon(
              onPressed: () async {
                String emaul = _editColEmail.text;
                  // 아이디, 비밀번호, 로그인 시간 
                },
              icon: Icon(
                // <-- Icon
                Icons.download,
                size: 24.0,
              ), // <-- Text
              label: Text("${title}"),
            ),
          ),
          //회원가입 아이디, 비밀번호, 비밀번호 확인, 핸드폰 번호
         SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    function().popbeforePage(context);
                  },
                  child: Text('비밀번호 찾기'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    function().popbeforePage(context);
                  },
                  child: Text('뒤로가기'),
                ),
              ),
               SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.of(context)
                                  .push(MaterialPageRoute<void>(
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

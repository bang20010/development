import 'package:cardapp/usecase/getCurrentSecond.dart';
import 'package:cardapp/usecase/getCurrentDate.dart';
import 'package:cardapp/utility/firebase_Store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../usecase/checkAddCardValue.dart';
import '../usecase/updateCard.dart';
import 'dart:io';

class updateCard extends StatefulWidget {
  const updateCard(
      {Key? key,
      required this.filename,
      required this.documentName,
      required this.User})
      : super(key: key);
  final String filename;
  final String documentName;
  final String User;
  @override
  updateCard_View createState() => updateCard_View();
}

class updateCard_View extends State<updateCard> {
  final _formKey = GlobalKey<FormState>();
  String localImge = "";
  late bool isButtonActive;

  final storageRef = FirebaseStorage.instance.ref();

  bool checkName = false;
  bool checkCompanyName = false;
  bool checkPosition = false;
  bool checkPhoneNum = false;
  bool checkHomePage = false;
  bool checkEmail = false;
  bool checkAddress = false;
  bool checkCompanyNum = false;

  bool isURLpic = true;

  late TextEditingController _editColName,
      _editColCompanyName,
      _editColPosition,
      _editColPhoneNum,
      _editColEmail,
      _editColAddress,
      _editColHomePage,
      _editColCompanyCallNum,
      _editColCreateDate;

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _nameFocus = new FocusNode();
  FocusNode _phoneFocus = new FocusNode();
  FocusNode _positionFocus = new FocusNode();
  FocusNode _companyNameFocus = new FocusNode();
  FocusNode _companyNumFocus = new FocusNode();
  FocusNode _addressFocus = new FocusNode();
  FocusNode _homepageFocus = new FocusNode();

  @override
  void initState() {
    isButtonActive = false;
    super.initState();
    // 생성자로 만드는 초기화 패턴
    _editColName = TextEditingController();
    _editColCompanyName = TextEditingController();
    _editColPosition = TextEditingController();
    _editColPhoneNum = TextEditingController();
    _editColEmail = TextEditingController();
    _editColHomePage = TextEditingController();
    _editColCompanyCallNum = TextEditingController();
    _editColCreateDate = TextEditingController();
    _editColAddress = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String User = widget.User;
    bool isValueActive = true;
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    final String filename = widget.filename;
    final String getDocumentName = widget.documentName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("명함 등록",
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
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    height: media_querysize.height / 4,
                    width: media_querysize.width - 40,
                    child: GestureDetector(
                        onTap: () async {
                          await ImagePicker()
                              .getImage(source: ImageSource.gallery)
                              .then(
                                  (pickedFile) => localImge = pickedFile!.path);
                          isURLpic = false;
                        },
                        child: isURLpic
                            ? Image.file(
                                File(localImge),
                                fit: BoxFit.cover,
                              )
                            : Image.network(filename)),
                  ),
                  _showNameInput(),
                  _showCompanyNameInput(),
                  _showCompanyNumInput(),
                  _showPhoneNumInput(),
                  _showEmailInput(),
                  _showPositionInput(),
                  _showAddressInput(),
                  _showHomePageInput(),
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
              onPressed: isButtonActive
                  ? () async {
                      String name = _editColName.text.trim();
                      String companyName = _editColCompanyName.text.trim();
                      String position = _editColPosition.text.trim();
                      String phoneNum = _editColPhoneNum.text.trim();
                      String email = _editColPhoneNum.text.trim();
                      String homePage = _editColEmail.text.trim();
                      String address = _editColAddress.text.trim();
                      String companyCallNum =
                          _editColCompanyCallNum.text.trim();
                      String createDateEndSecond =
                          getCurrentSecond().trim();
                      String path = filename;
                      String url = "";
                      String createEndDate = getCurrentDate().trim();
                      String document = getDocumentName;
                    if(isURLpic){
                      await updateCardData(
                          context,
                          User,
                          path,
                          name,
                          companyName,
                          position,
                          phoneNum,
                          email,
                          homePage,
                          address,
                          companyCallNum,
                          createEndDate,
                          createDateEndSecond,
                          document,
                          isURLpic);
                          }
                      else if(!isURLpic){
                            await updateCardData(
                          context,
                          User,
                          localImge,
                          name,
                          companyName,
                          position,
                          phoneNum,
                          email,
                          homePage,
                          address,
                          companyCallNum,
                          createEndDate,
                          createDateEndSecond,
                          document,
                          isURLpic);
                          }
                      }
                  : null,
              icon: Icon(
                // <-- Icon
                Icons.download,
                size: 24.0,
              ), // <-- Text
              label: Text("저장하기"),
            ),
          ),
          SizedBox(
            child: ElevatedButton.icon(
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                popAddCard(context, filename);
              },
              label: Text('뒤로가기'),
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

  Widget _showNameInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColName,
                  focusNode: _nameFocus,
                  inputFormatters: [],
                  decoration: _textFormDecoration('이름'),
                  onSaved: (value) {
                    setState(() {
                      _editColName.text = value as String;
                    });
                  },
                  validator: (String? value) {
                    RegExp isValue = RegExp(r"^[ㄱ-ㅎ가-힣]*$");
                    if (value!.isEmpty) {
                      return "이름이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      checkName = true;
                      return null;
                    } else {
                      return "이름을 정확히 입력해주세요.";
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
                      checkPhoneNum = true;
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

  Widget _showCompanyNameInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColCompanyName,
                  focusNode: _companyNameFocus,
                  decoration: _textFormDecoration('회사이름'),
                  onSaved: (value) {
                    setState(() {
                      _editColCompanyName.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(r"^[ㄱ-ㅎ가-힣0-9a-zA-Z\s+]*$");
                    if (value!.isEmpty) {
                      return "회사이름이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      checkCompanyName = true;
                      return null;
                    } else {
                      return "회사이름을 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  Widget _showCompanyNumInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColCompanyCallNum,
                  focusNode: _companyNumFocus,
                  decoration: _textFormDecoration('회사번호'),
                  onSaved: (value) {
                    setState(() {
                      _editColCompanyCallNum.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(
                        r'^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$');
                    if (value!.isEmpty) {
                      return "회사번호이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      checkCompanyNum = true;
                      return null;
                    } else {
                      return "회사번호을 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  Widget _showPositionInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColPosition,
                  focusNode: _positionFocus,
                  decoration: _textFormDecoration('직책'),
                  onSaved: (value) {
                    setState(() {
                      _editColPosition.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(r"^[ㄱ-ㅎ가-힣0-9a-zA-Z]*$");
                    if (value!.isEmpty) {
                      return "직책이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      checkPosition = true;
                      return null;
                    } else {
                      return "직책을 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  Widget _showAddressInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColAddress,
                  focusNode: _addressFocus,
                  decoration: _textFormDecoration('회사주소'),
                  onSaved: (value) {
                    setState(() {
                      _editColAddress.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(r"^[ㄱ-ㅎ가-힣0-9]*$");
                    if (value!.isEmpty) {
                      return "회사 주소이 비어있습니다.";
                    }
                    if (isValue.hasMatch(value)) {
                      checkAddress = true;

                      if (CheckAddCardValue(
                          checkCompanyName,
                          checkPosition,
                          checkPhoneNum,
                          checkHomePage,
                          checkEmail,
                          checkAddress,
                          checkCompanyNum)) {
                        isButtonActive = true;
                      }
                      return null;
                    } else {
                      return "회사 주소를 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                )),
          ],
        ));
  }

  Widget _showHomePageInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _editColHomePage,
                  focusNode: _homepageFocus,
                  onSaved: (value) {
                    setState(() {
                      _editColHomePage.text = value as String;
                    });
                  },
                  validator: (value) {
                    RegExp isValue = RegExp(r'^[a-zA-Z+]+\.[a-zA-Z]+');
                    if (value!.isEmpty) {
                      checkHomePage = true;

                      return null;
                    }
                    if (isValue.hasMatch(value)) {
                      return null;
                    } else {
                      return "홈페이지 정확히 입력해주세요.";
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                  decoration: _texthelperDecoration(
                      '회사 홈페이지', '홈페이지를 입력해주세요 미 입력시 "없음"으로 자동입력'),
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
  void popAddCard(final context, String filename) {
    filename = "";
    Navigator.pop(context);
  }
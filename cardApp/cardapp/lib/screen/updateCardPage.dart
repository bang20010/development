import 'package:cardapp/usecase/getCurrentSecond.dart';
import 'package:cardapp/usecase/getCurrentTDate.dart';
import 'package:cardapp/utility/firebase_Store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import '../usecase/checkAddCardValue.dart';
import '../usecase/updateCard.dart';
import 'dart:io';

class updateCard extends StatefulWidget {
  const updateCard({Key? key, required this.documentName, required this.User})
      : super(key: key);
  final String documentName;
  final String User;
  @override
  updateCard_View createState() => updateCard_View();
}

class updateCard_View extends State<updateCard> {
  bool isLoading = true;
  String path = "";
  // String _ocrText = "";
  Map<String, String> ocrTextMap = {"name": "", "email": "", "phonenumber": ""};
  bool checkName = false;
  bool checkCompanyName = false;
  bool checkPosition = false;
  bool checkPhoneNum = false;
  bool checkHomePage = false;
  bool checkEmail = false;
  bool checkAddress = false;
  bool checkCompanyNum = false;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editColName,
      _editColCompanyName,
      _editColPosition,
      _editColPhoneNum,
      _editColEmail,
      _editColAddress,
      _editColHomePage,
      _editColCompanyCallNum;

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _nameFocus = new FocusNode();
  FocusNode _phoneFocus = new FocusNode();
  FocusNode _positionFocus = new FocusNode();
  FocusNode _companyNameFocus = new FocusNode();
  FocusNode _companyNumFocus = new FocusNode();
  FocusNode _addressFocus = new FocusNode();
  FocusNode _homepageFocus = new FocusNode();

  bool isImage = false;
  bool isButtonActive = false;

  void runCameraPiker() async {
    // android && ios only
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera)
        .then((pickedFile) {
      if (pickedFile != null) {
        path = pickedFile.path;
      }
    }, onError: (e) {
      errorDialog(context, "${e}에러가 발생했습니다.");
    });
    if (pickedFile != null) {
      path = pickedFile.path;
      _ocr(pickedFile.path);
      isImage = true;
    }
  }

  void runGalleryPiker() async {
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) {
      if (pickedFile != null) {
        _ocr(pickedFile.path);
        setState(() {
          path = pickedFile!.path;
          isImage = true;
        });
      }
    }, onError: (e) {
      errorDialog(context, "${e}에러가 발생했습니다.");
    });
  }

  void getOcrText(
      String _ocrText, String pattern, TextEditingController controller) async {
    RegExp isValue = RegExp(pattern);
    var match = isValue.firstMatch(_ocrText);
    String? name = match?.group(0);
    if (name != null) {
      controller.text = name!;
    }
  }

  void _ocr(url) async {
    var selectList = ["eng", "kor"];
    var langs = selectList.join("+");
    // 위젯을 처음부터 로드
    setState(() {});
    isLoading = false;
    String _ocrText =
        await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });
    getOcrText(_ocrText, "010-?([0-9]{4})-?([0-9]{4})", _editColPhoneNum);
    getOcrText(
        _ocrText,
        "[김이박최정강조윤장임한오서신권황안송전홍유고문양손배조백허유남심노정하곽성차주우구신임전민유류나진지엄채원천방공강현함변염양변염양변여추]{1}?[가-힣]{2,4}",
        _editColName);
    getOcrText(
        _ocrText,
        "[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}",
        _editColEmail);
    getOcrText(
        _ocrText,
        "[사원]|[주임]|[대리]|[과장]|[차장]|[부장]|[이사]|[상무]|[부사장]|[사장]|[대표]|[박사]|[연구원]|[프리랜서][실장]",
        _editColPosition);
    isLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    isButtonActive = false;
    super.initState();

    // textFlied 생성자로 만드는 초기화 패턴
    _editColName = TextEditingController();
    _editColCompanyName = TextEditingController();
    _editColPosition = TextEditingController();
    _editColPhoneNum = TextEditingController();
    _editColEmail = TextEditingController();
    _editColHomePage = TextEditingController();
    _editColCompanyCallNum = TextEditingController();
    _editColAddress = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var media_querysize = MediaQuery.of(context).size;
    // String filename = widget.filename;
    String User = widget.User;
    String title = "명함 수정";

    return isLoading
        ? Scaffold(
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
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          height: media_querysize.height / 4,
                          width: media_querysize.width - 40,
                          child: isImage
                              ? GestureDetector(
                                  onTap: () {
                                    runGalleryPiker();
                                  },
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Column(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                    ),
                                    Text(
                                      "명함사진을 추가해주세요",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    ),
                                    TextButton.icon(
                                        label: Text("갤러리에서 스캔하기"),
                                        icon: Icon(Icons.add, size: 18),
                                        onPressed: () async {
                                          runGalleryPiker();
                                          if (path.isNotEmpty) {
                                            isImage = true;
                                          } else {
                                            isImage = false;
                                          }
                                        }),
                                    TextButton.icon(
                                        label: Text("카메라로  스캔하기"),
                                        icon: Icon(Icons.camera_alt, size: 18),
                                        onPressed: () {}),
                                  ],
                                )),
                        ),
                        _showNameInput(),
                        _showCompanyNameInput(),
                        _showCompanyNumInput(),
                        _showPhoneNumInput(),
                        _showEmailInput(),
                        _showPositionInput(),
                        _showAddressInput(),
                        _showHomePageInput(),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: media_querysize.width - 234,
                          height: media_querysize.height / 28,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onSurface: Colors.blue,
                            ),
                            onPressed: isButtonActive
                                ? () async {
                                    String name = _editColName.text.trim();
                                    String companyName =
                                        _editColCompanyName.text.trim();
                                    String position =
                                        _editColPosition.text.trim();
                                    String phoneNum =
                                        _editColPhoneNum.text.trim();
                                    String email = _editColEmail.text.trim();
                                    String homePage = _editColHomePage.text.trim();
                                    String address =
                                        _editColAddress.text.trim();
                                    String companyCallNum =
                                        _editColCompanyCallNum.text.trim();
                                    String createDateEndSecond =
                                        getCurrentSecond().trim();
                                    String url = "";
                                    String createEndDate =
                                        getCurrentDate().trim();
                                    String document = widget.documentName;
                                    if (path.isNotEmpty) {
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
                                      ).then(
                                        (value) {
                                          Navigator.of(context).pop();
                                          // value as Map;
                                          // if (value["result"] == true) {
                                          //   Navigator.of(context).pop();
                                          // } else if (value["result"] == false) {
                                          //   String error = value["error"];명
                                          //   errorDialog(context, error);
                                          // }
                                        },
                                        onError: (e){errorDialog(context, "${e} 에러가 발생했습니다.");}
                                      );
                                    } else {
                                      errorDialog(context, "이미지를 선택해주세요");
                                    }

                                  }
                                : null, // <-- Text
                            child: Text("명함수정"),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            // bottomNavigationBar: Container(
            //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [

            //         SizedBox(
            //           child: ElevatedButton.icon(
            //             icon: Icon(Icons.arrow_back_ios_new_outlined),
            //             onPressed: () {
            //               popAddCard(context, "filename");
            //             },
            //             label: Text('뒤로가기'),
            //           ),
            //         ),
            //       ]),
            // ),
          )
        : Scaffold(
            body: Center(
              child: Column(children: [
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(height: 400,),
                      Text(
                        "이미지를 스캔하는 중입니다.",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SpinKitCircle(
                        size: 14,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                )
              ]),
            ),
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

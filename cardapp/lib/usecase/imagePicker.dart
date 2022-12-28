// import 'package:flutter/material.dart';
// import 'package:flutter_tesseract_ocr/android_ios.dart';
// import 'package:image_picker/image_picker.dart';

// void runImagePiker(BuildContext context, String User) async {
//   // android && ios only
//   String secanValue = "";
//   final pickedFile =
//       await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
//     if (value != null) {
//      secanValue = _ocr(value.path);
//     }
//   }, onError: (e) {
//     Navigator.pop(context);
//   }).then((value){ 
//     Navigator.of(context).push(MaterialPageRoute<void>(
//                     builder: (BuildContext context) => getTextPage(user: User, takePicture: true),
//  } );
// }

// Future<String> _ocr(url) async {
//   var selectList = ["eng", "kor"];
//   var langs = selectList.join("+");
//   return FlutterTesseractOcr.extractText(url, language: langs, args: {
//     "preserve_interword_spaces": "1",
//   });
// }

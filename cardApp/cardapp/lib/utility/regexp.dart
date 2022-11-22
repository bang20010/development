import 'package:flutter/material.dart'; 

class regexp {
      RegExp isEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      RegExp isPhoneNum = RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$');
      RegExp isCompanyNum = RegExp(r'^(0?[d]{2-3}})-?([0-9]{4})-?([0-9]{4})$');
      RegExp isName = RegExp(r'^([가-힣\s+]{2-6}$)');
      RegExp isHomepage = RegExp(r'^[a-zA-Z\s+]+\.[a-zA-Z]+$');
      RegExp isString = RegExp(r'^[ㄱ-ㅎ가-힣0-9a-zA-Z\s+]$');
      RegExp isKorean = RegExp(r'^[ㄱ-ㅎ가-힣\s+]$');

      
      String isInput = "을 입력하세요.";
      String isNotValue = "정확한 값을 입력해주세요";

    // bool isEmailValueFormat(FocusNode focusNode ,String value) {
    //   bool rtnValue = false;
    // if(value.isNotEmpty && isEmail.hasMatch(value)){
    //         return null;
    // }
    // return rtnValue;    
    // }

    String? validateName(String value) {
    String pattern = r"^[ㄱ-ㅎ가-힣]*$";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
          return '이름을 입력해주세요.';
    }
    else if (!regExp.hasMatch(value)) {
      return '이름을 정확히 입력해주세요.';
    }
    return null;
  }                       

    String? isNameValueFormat(FocusNode focusNode ,String value) {
    RegExp isName = RegExp(r"^[ㄱ-ㅎ가-힣]*$");
    if(value.isEmpty){
      return "이름이 비어있습니다.";
    }
    if(isName.hasMatch(value)){
      return null;
    }else{
      return "이름을 정확히 입력해주세요.";
    }
    }
    String isValidPhoneFormat(FocusNode focusNode ,String value) {
    if(value.isEmpty){
      return "핸드폰 번호를 ${isInput}";
    }
    if(value.isNotEmpty && isPhoneNum.hasMatch(value)){
            return value;
    }else{
      return isNotValue;
    }
    }
    String isValidCompanyNumFormat(FocusNode focusNode ,String value) {
    if(value.isEmpty){
      return "핸드폰 번호를 ${isInput}";
    }
    if(value.isNotEmpty && isCompanyNum.hasMatch(value)){
            return value;
    }else{
      return isNotValue;
    }
    }


    String isValidStringFormat(FocusNode focusNode ,String value) {
    if(value.isEmpty){
      return "문자를 ${isInput}";
    }
    if(value.isNotEmpty && isString.hasMatch(value)){
            return value;
    }else{
      return isNotValue;
    }
    }

}

  bool CheckAddCardValue(
      bool checkCompanyName,
      bool checkPosition,
      bool checkPhoneNum,
      bool checkHomePage,
      bool checkEmail,
      bool checkAddress,
      bool checkCompanyNum
      ) {
    if (checkCompanyName &&
        checkPosition &&
        checkPhoneNum &&
        checkHomePage &&
        checkEmail &&
        checkAddress &&
        checkCompanyNum) {

          return true;
    }
    return false;
  }

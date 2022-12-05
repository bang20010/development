    import 'package:flutter/widgets.dart';

import '../utility/firebase_Store_User.dart';

bool checkEmail( BuildContext context, String email) {
      bool checkID = true;    
      FireStoreApp_User().getUserCollect().get().then((snapshot) {
      snapshot.docs.forEach((doc){
        print(doc);
        if (doc.id == email) {
          doc;
          doc.id;
          checkID = false;
        }
      });
    });
      if(checkID){
      return checkID;
      }
      else{
      return checkID;
      }
    }

import 'package:cardapp/utility/function.dart'; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardapp/screen/mainPage.dart';
import 'package:flutter/material.dart';
import '../screen/signinPage.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signIn(BuildContext context, String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
          onError: (e) =>
              function().errorDialog(context, "${e} 로그인 정보가 다릅니다. "),
          (doc) => {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) => mainPage(
                email: email,
              ),
            ))
          },
        );
  }

  Future signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => signinPage(),
    ));
  }

  Future signUp(BuildContext context, String email, String password) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
          (doc) => function().addDialog(context, "${email} 회원을  생성했습니다."),
          onError: (e) => function().errorDialog(
              context, "${e}.. Eorror ${email}에 회원생성을 실패했습니다. 다시 시도해주세요"),
        );
  }

  Future SearchPassword(BuildContext context, String email) async {
    await auth.sendPasswordResetEmail(email: email).then(
          (doc) => function().addDialog(context, "${email} 회원으로 비밀번호를 보냈습니다."),
          onError: (e) =>
              function().errorDialog(context, "등록된 ${email}이 없습니다. 다시 입력해주세요"),
        );
  }

  //구글 로그인 미 구현
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
    return user;
  }
}

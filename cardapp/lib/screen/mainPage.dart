import 'package:cardapp/screen/signinPage.dart';
import 'package:cardapp/screen/updateCardPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../usecase/signOut.dart';
import '../usecase/removeCard.dart';
import 'addCardPage.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  mainPage_View createState() => mainPage_View();
}

class mainPage_View extends State<mainPage> {
  static bool checkImage = false;
  String path = "";
  late bool isButtonActive;

  @override
  void initState() {
    // User user = widget._user;
    // TODO: implement initState
    super.initState();
    // 생성자로 만드는 초기화 패턴
  }

  @override
  Widget build(BuildContext context) {
    String User = widget.email;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var media_querysize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: _NavBar(User),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text("명함 지갑",
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
        ),
        // StreamBuilder로 firebase값을 불러오는게 아니라 initstate안에 firestore 값을 다 불러온다.
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("CardData")
                .doc(User)
                .collection("CardList")
                .orderBy("createDate")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _loading();
              } else if (snapshot.hasData) {
                final snap = snapshot.data!.docs;
                if (snap.length == 0) {
                  return Center(
                    child: Text("등록된 명함이 없습니다. 명함을 등록해주세요. ",
                        style: TextStyle(fontSize: 16)),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return Expanded(
                        child: Container(
                            width: media_querysize.width,
                            height: media_querysize.height / 2 - 50,
                            child: Column(
                              children: [
                                Wrap(
                                  children: [
                                    SizedBox(
                                      child: Column(children: [
                                        SizedBox(
                                          width: media_querysize.width,
                                          height: 250,
                                          child: Image.network(
                                            snap[index]["url"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          width: media_querysize.width,
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                child: Expanded(
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 5,
                                                    strutStyle: StrutStyle(
                                                        fontSize: 16.0),
                                                    text: TextSpan(
                                                        text: "회사 이름 : " +
                                                            snap[index][
                                                                "companyName"] +
                                                            "\n이름 : " +
                                                            snap[index]
                                                                ["name"] +
                                                            "\n핸드폰 번호 : " +
                                                            snap[index]
                                                                ["phoneNum"] +
                                                            "\n회사번호 번호 : " +
                                                            snap[index][
                                                                "companyCallNum"],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            height: 1.4,
                                                            fontSize: 15.0,
                                                            fontFamily:
                                                                'NanumSquareRegular')),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  child: Expanded(
                                                child: Column(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          String
                                                              getDocumentName =
                                                              snap[index]
                                                                  ["document"];
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                                  MaterialPageRoute<
                                                                      void>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                updateCard(
                                                                    documentName:
                                                                        getDocumentName,
                                                                    User: User),
                                                          ));
                                                        },
                                                        child: Text("수정")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          String
                                                              getDocumentName =
                                                              snap[index].id;
                                                          isDeleteDialog(
                                                              context,
                                                              "명함을 삭제하시겠습니까?",
                                                              User,
                                                              snap[index]
                                                                  ["document"]);
                                                        },
                                                        child: Text("삭제"))
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    });
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text("에러"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('데이터를 불러오는데 오류가 발생했습니다. 다시 로그인 해주세요'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('확인'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) => signinPage(),
                        ));
                      },
                    ),
                  ],
                );
              } else {
                return Center(child: Text("등록된 명함이 없습니다. 명함을 등록해주세요"));
              }
            }),
        bottomNavigationBar: Container(
          width: media_querysize.width,
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text("명함 추가"),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => addCard(email: User)),
              );
            },
          ),
        ));
  }

  Widget _NavBar(String User) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(User),
            accountEmail: Text('환영합니다'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Icon(
                  Icons.account_circle,
                  size: 70,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            title: Text('로그아웃'),
            onTap: () async {
              signOut().then((value) {}, onError: (e) {
                errorDialog(context, "${e} 에러가 발생했습니다.");
              });
            },
          ),
          ListTile(
            title: Text('뒤로가기'),
            onTap: () {
              popbeforePage(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget addBusCard(BuildContext context, String User) {
  return
      // Container(
      // color: Colors.grey,
      // decoration: BoxDecoration( color:  Colors.grey ,borderRadius: BorderRadius.circular(15)),
      CircleAvatar(
    radius: 30,
    backgroundColor: Colors.grey,
    child: IconButton(
      icon: Icon(
        Icons.search,
        color: Colors.white,
      ),
      onPressed: () {},
    ),
  );
  // IconButton(
  //     icon: Icon(Icons.add, color: Colors.white),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.grey,
  //         primary: Color.fromARGB(255, 232, 232, 232), onPrimary: Colors.white),
  //     onPressed: () async {
  //       //  runImagePiker(User);
  //       await Navigator.of(context).push(MaterialPageRoute<void>(
  //         builder: (BuildContext context) => addCard(email: User),
  //       ));
  //     }),
  // );
}

void isDeleteDialog(
    BuildContext context, String value, String User, String companyNume) async {
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
            onPressed: () async {
              await deleteCard(User, companyNume).then((value) {
                Navigator.of(context).pop();
              }, onError: (e) {
                errorDialog(context, "${e} 에러가 발생했습니다.");
              });
            },
          ),
          TextButton(
            child: const Text('뒤로가기'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void popbeforePage(final context) {
  Navigator.pop(context);
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

Widget _loading() {
  return Center(
      child: CircularProgressIndicator(
    strokeWidth: 10,
  ));
}

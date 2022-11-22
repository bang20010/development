import 'package:cardapp/screen/getTextPage.dart';
import 'package:cardapp/screen/signinPage.dart';
import 'package:cardapp/utility/function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../utility/firebase_ Authentication.dart';
import '../utility/firebase_Store.dart';
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

  void runImagePiker(String User) async {
    // android && ios only
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => path = pickedFile!.path);
    if (path != "") {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
            builder: (BuildContext context) => addCard(
              filename: path,
              email: User,
            ),
          ))
          .then((value) => null);
    }
  }

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
              return  Center(child : CircularProgressIndicator(
                strokeWidth: 10,
              ));
            } else if (snapshot.hasData) {
              final snap = snapshot.data!.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snap.length,
                  itemBuilder: (context, index) {
                    return Expanded(
                      child: Container(
                        width: media_querysize.width,
                        height: media_querysize.height / 2 - 50,
                        child: Wrap(
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: media_querysize.width,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          child: Expanded(
                                              child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        strutStyle: StrutStyle(fontSize: 16.0),
                                        text: TextSpan(
                                            text: "회사 이름 : " +
                                                snap[index]["companyName"] +
                                                "\n이름 : " +
                                                snap[index]["name"] +
                                                "\n핸드폰 번호 : " +
                                                snap[index]["phoneNum"] +
                                                "\n회사번호 번호 : " +
                                                snap[index]["companyCallNum"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                height: 1.4,
                                                fontSize: 15.0,
                                                fontFamily:
                                                    'NanumSquareRegular')),
                                      ))),
                                      SizedBox(
                                          child: Expanded(
                                        child: Column(
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  String getDocumentName =
                                                      snap[index]["document"];
                                                  await FireStoreApp()
                                                      .getUpdateCard(
                                                          User,
                                                          getDocumentName,
                                                          context);
                                                },
                                                child: Text("수정 하기")),
                                            TextButton(
                                                onPressed: () async {
                                                  String getDocumentName =
                                                      snap[index]["document"];
                                                  function().addDialog(
                                                      context, "명함을 삭제하시겠습니까?");
                                                  await FireStoreApp()
                                                      .deleteCard(context, User,
                                                          getDocumentName);
                                                },
                                                child: Text("삭제 하기"))
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
                      ),
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
      bottomNavigationBar:  
      Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 232, 232, 232), onPrimary: Colors.black),
                child: Text("이미지"),
                onPressed: () {
                  checkImage = true;
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => getTextPage(user: User),
                  ));
                }),
          ),
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 232, 232, 232), onPrimary: Colors.black),
                child: Text("스캔"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => getTextPage(user: User),
                  ));
                }),
          ),
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 232, 232, 232), onPrimary: Colors.black),
                child: Text("수동 등록"),
                onPressed: () async {
                  runImagePiker(User);
                  // await Navigator.of(context).push(MaterialPageRoute<void>(
                  //   builder: (BuildContext context) => const addCard(),
                  // ));
                }),
          ),
        ]),
      ),
    );
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
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
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
            onTap: () => Authentication().signOut(context),
          ),
          ListTile(
            title: Text('뒤로가기'),
            onTap: () => function().popbeforePage(context),
          ),
        ],
      ),
    );
  }
}

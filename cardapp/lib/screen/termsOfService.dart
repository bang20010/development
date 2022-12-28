import 'package:flutter/material.dart';

class termsOfService extends StatefulWidget {
  const termsOfService({Key? key}) : super(key: key);
  @override
  termsOfService_View createState() => termsOfService_View();
}

class termsOfService_View extends State<termsOfService> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media_querysize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("이용 약관",
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
              "개인정보 보호, 보안 개인정보 수집 및 활용 개인정보는 개인 식별 정보, 금융 및 결제 정보, 인증 정보 및 개인 식별 정보에 연결하여 간접적으로 이용자를 식별할 수 있는 모든 정보를 의미합니다.\n 개인정보를 수집하는 상품은 개인정보의 수집 전 개인정보 수집에 대한 명시적인 이용자 동의절차를 구현하여야 합니다.\n\n 개인정보의 수집 동의 시, 수집하는 개인정보의 항목과 목적, 보유기간을 반드시 포함하여야 합니다.\n 개인정보를 수집하는 상품은 ‘개인정보처리방침’을 공개하여야 합니다. \n개인정보 처리방침 작성 예시 위치정보의 보호 및 이용 등에 관한 법률에 따라 개인위치정보를 대상으로 하는 위치정보사업을 영위하는 경우, ‘위치기반서비스 사업자 신고필증’을 첨부하여야 합니다. 앱 접근권한 법규 준수 접근권한을 서비스에 필요한 범위 내로 최소화해야 합니다. \n\n 접근권한에 대한 동의를 받기 전 필수적 접근권한과 선택적 접근권한을 구분하여 접근권한이 필요한 항목 및 그 이유 등을 이용자에게 알기 쉽게 고지한 후, 동의를 받아야 합니다. \n\n 방송통신위원회 스마트폰 앱 접근권한 개인정보보호 안내서 악성행위 방지 이용자의 데이터 또는 기기를 위험에 노출 시킬 수 있는 모든 악의적인 코드 또는 행위를 금지합니다. (예: 바이러스, 스파이웨어, 트로이 목마, 애드웨어, 루팅 등) 이용자의 기기 및 프로그램, Network를 이용하여 이용자 및 타인에게 해를 끼치는모든  코드 또는 행위를 금지합니다. \n\n (예: 스팸, DDoS, 크립토재킹 등) 이용자에게 불편을 초래하거나 사용자를 속이는 모든 코드 또는 행위를 금지합니다. (예: 피싱, 사기광고 등)",
              style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: media_querysize.width - 234,
            height: media_querysize.height / 28,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('뒤로 가기'),
            ),
          ),
        ],
      )),
    );
  }
}

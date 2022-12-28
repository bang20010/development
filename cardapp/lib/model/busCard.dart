import 'dart:convert';

List<busCard> busCardFromJson(String str) =>
    List<busCard>.from(json.decode(str).map((x) => busCard.fromJson(x)));

String busCardToJson(List<busCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class busCard {
  String name;
  String companyName;
  String position;
  String phoneNum;
  String email;
  String? homePage;
  String address;
  String companyCallNum;
  String createDate;
  String url;
  String document;

  busCard(
      {required this.name,
      required this.companyName,
      required this.phoneNum,
      required this.email,
      required this.position,
      required this.address,
      required this.companyCallNum,
      required this.createDate,
      required this.url,
      required this.document,
      this.homePage});

  factory busCard.fromJson(Map<String, dynamic> json) => busCard(
      name: json["name"],
      companyName: json["companyName"],
      phoneNum: json["phoneNum"],
      position: json["position"],
      homePage: json["homePage"],
      address: json["address"],
      companyCallNum: json["companyCallNum"],
      email: json["email"],
      createDate: json["createDate"],
      document: json["document"],
      url: json["url"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "companyName": companyName,
        "phoneNum": phoneNum,
        "email": email,
        "homePage": homePage,
        "address": address,
        "companyCallNum": companyCallNum,
        "createDate": createDate,
        "url": url,
        "document": document
      };
  //flutter map 데이터 받아오기
}

import 'dart:convert'; 


List<UserPhoneNum> busCardFromJson(String str) =>
    List<UserPhoneNum>.from(json.decode(str).map((x) => UserPhoneNum.fromJson(x)));

String busCardToJson(List<UserPhoneNum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPhoneNum {
  String phoneNum;
  String email;
  String createDate;

  UserPhoneNum(
      {
      required this.phoneNum,
      required this.email,
      required this.createDate,
});

  factory UserPhoneNum.fromJson(Map<String, dynamic> json) => UserPhoneNum(
      phoneNum: json["phoneNum"],
      email: json["email"],
      createDate: json["createDate"]
      );

  Map<String, dynamic> toJson() => {
        "phoneNum": phoneNum,
        "email": email,
        "createDate": createDate,
      };
}

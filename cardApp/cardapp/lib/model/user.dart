import 'dart:convert'; 



List<User> busCardFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String busCardToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String phoneNum;
  String email;
  String password;
  String createDate;

  User(
      {
      required this.phoneNum,
      required this.email,
      required this.password,
      required this.createDate,
});

  factory User.fromJson(Map<String, dynamic> json) => User(
      phoneNum: json["phoneNum"],
      password: json["password"],
      email: json["email"],
      createDate: json["createDate"]
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "phoneNum": phoneNum,
        "email": email,
        "createDate": createDate,
      };
}

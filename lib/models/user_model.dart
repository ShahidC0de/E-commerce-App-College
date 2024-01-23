// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fronJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.streetAddress,
  });

  String? image;
  String id;
  String name;
  String email;
  String streetAddress;

  factory UserModel.fronJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        streetAddress: json["streetAddress"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "streetAddress": streetAddress,
      };
  UserModel copyWith({
    String? name,
    image,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        // ignore: unnecessary_this
        image: image ?? this.image,
        streetAddress: streetAddress,
      );

  static fromJson(decode) {}
}

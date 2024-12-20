// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

UserModel userModelFromJson(Map<String, dynamic> json) =>
    UserModel.fromJson(json);

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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
    String? image,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        image: image ?? this.image,
        streetAddress: streetAddress,
      );
}

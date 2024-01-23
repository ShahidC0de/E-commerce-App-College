// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

CategoryModelFromJson(String str) => CategoryModelFromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.image,
    required this.id,
    required this.name,
  });

  String image;
  String id;
  String name;

  factory CategoryModel.fronJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
      };
}

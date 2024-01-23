import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.isFavourate,
    this.qty,
  });

  String image;
  String id;
  String name;
  double price;
  String description;

  bool isFavourate;
  int? qty;

  factory ProductModel.fronJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? "",
        qty: json["qty"],
        image: json["image"] ?? "default_image_url",
        isFavourate: json["isFavourate"] ?? false,
        price: double.parse(json["price"].toString()),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "price": price,
        "isFavourate": isFavourate,
        "qty": qty,
      };
  ProductModel copyWith({
    int? qty,
  }) =>
      ProductModel(
        id: id,
        name: name,
        description: description,
        qty: qty ?? this.qty,
        image: image,
        isFavourate: isFavourate,
        price: price,
      );

  static fromJson(decode) {}
}

import 'package:json_annotation/json_annotation.dart';
part 'product.model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductModel {
  final String id;
  final String name;
  final int price;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

import 'package:commerce_app/model/product.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket.model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class BasketModel extends ProductModel {
  final int quantity;

  BasketModel({
    required super.imageUrl,
    required super.price,
    required super.name,
    required super.id,
    required this.quantity,
  });

  factory BasketModel.fromJson(Map<String, dynamic> json) =>
      _$BasketModelFromJson(json);

  Map<String, dynamic> toJson() => _$BasketModelToJson(this);


  BasketModel copyWith({
    int? quantity,
  }) {
    return BasketModel(
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      price: price,
      name: name,
      id: id,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductModel &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

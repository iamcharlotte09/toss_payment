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

  // Override the equality operator to compare product objects by their IDs
  @override
  bool operator ==(Object other) {
    return other is ProductModel &&
        other.id == id; // Check if the IDs are the same
  }

  // Override the hashCode to match the == operator logic
  @override
  int get hashCode => id.hashCode;
}

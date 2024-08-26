import 'package:commerce_app/model/basket.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class OrderModel extends BasketModel {
  final DateTime createdAt;

  OrderModel({
    required super.imageUrl,
    required super.price,
    required super.name,
    required super.id,
    required super.quantity,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketModel _$BasketModelFromJson(Map<String, dynamic> json) => BasketModel(
      imageUrl: json['image_url'] as String,
      price: (json['price'] as num).toInt(),
      name: json['name'] as String,
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$BasketModelToJson(BasketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'quantity': instance.quantity,
    };

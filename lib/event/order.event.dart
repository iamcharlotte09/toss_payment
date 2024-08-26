import 'dart:convert';

import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/model/order.model.dart';
import 'package:uuid/uuid.dart';

class OrderEvent {}

class CreateOrder extends OrderEvent {
  final List<BasketModel> basket;
  final String orderId;

  CreateOrder({
    required this.basket,
    required this.orderId,
  });
}

class GetOrders extends OrderEvent {}

class ChangePaymentStatus extends OrderEvent {
  final String orderId;

  ChangePaymentStatus({required this.orderId});
}

import 'package:commerce_app/model/order.model.dart';

class OrderState{
  final List<OrderModel?> orders;

  OrderState({
    this.orders = const [],
  });
}

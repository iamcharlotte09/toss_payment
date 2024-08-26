import 'package:commerce_app/model/basket.model.dart';

class BasketState {
  final List<BasketModel?> basket;

  BasketState({
    this.basket = const [],
  });
}

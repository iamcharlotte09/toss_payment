import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/model/product.model.dart';

abstract class BasketEvent {}

class AddBasket extends BasketEvent {
  final ProductModel product;

  AddBasket({required this.product});
}

class SubtractBasket extends BasketEvent {
  final ProductModel product;
  final bool isRemoveAll;

  SubtractBasket({
    required this.product,
    this.isRemoveAll = false,
  });
}

class RemoveMultipleBasket extends BasketEvent {
  final List<String> basketIds;

  RemoveMultipleBasket({
    required this.basketIds,
  });
}

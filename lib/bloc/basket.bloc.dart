import 'package:commerce_app/event/basket.event.dart';
import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/state/basket.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  List<BasketModel?> _basket = [];

  BasketBloc() : super(BasketState()) {
    on<AddBasket>(_onAddBasket);
    on<SubtractBasket>(_onSubtractBasket);
    on<RemoveMultipleBasket>(_onRemoveMultipleBasket);
  }

  void _onAddBasket(AddBasket event, Emitter<BasketState> emit) async {
    try {
      if (_basket.contains(event.product)) {
        _basket = _basket
            .map((e) => e!.id == event.product.id
                ? e.copyWith(quantity: e.quantity + 1)
                : e)
            .toList();

        emit(BasketState(basket: _basket));
      } else {
        _basket.add(
          BasketModel(
              imageUrl: event.product.imageUrl,
              price: event.product.price,
              name: event.product.name,
              id: event.product.id,
              quantity: 1),
        );
        emit(BasketState(basket: _basket));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _onSubtractBasket(
      SubtractBasket event, Emitter<BasketState> emit) async {
    try {
      if (_basket.contains(event.product)) {
        final product = _basket.firstWhere((e) => e!.id == event.product.id);
        if (product!.quantity == 1 || event.isRemoveAll) {
          _basket.remove(product);

          emit(BasketState(basket: _basket));
        } else {
          _basket = _basket
              .map((e) => e!.id == event.product.id
                  ? e.copyWith(quantity: e.quantity - 1)
                  : e)
              .toList();

          emit(BasketState(basket: _basket));
        }
      } else {
        return;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _onRemoveMultipleBasket(
      RemoveMultipleBasket event, Emitter<BasketState> emit) async {
    try {
      _basket= _basket.where((e) => !event.basketIds.contains(e!.id)).toList();

      emit(BasketState(basket: _basket));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

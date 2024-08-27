import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/event/order.event.dart';
import 'package:commerce_app/model/order.model.dart';
import 'package:commerce_app/repository/order.repository.dart';
import 'package:commerce_app/state/order.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  List<OrderModel?> _orders = [];
  final OrderRepository repository;
  final AuthBloc authBloc;

  OrderBloc({
    required this.repository,
    required this.authBloc,
  }) : super(OrderState()) {
    on<CreateOrder>(_onCreateOrder);
    on<GetOrders>(_onGetOrders);
    on<ChangePaymentStatus>(_onChangePaymentStatus);
  }

  String _getUserId(){
    final authState = authBloc.state;
    final userId = authState.user?.id;

    if (userId != null) {
      return userId;
    }else{
      throw Exception('UserId 가 없습니다.');
    }
  }

  void _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    try {
      final userId = _getUserId();
      final quantity = event.basket.fold(0, (p, item) => p + item.quantity);
      final firstItem = event.basket.first;
      final totalPrice =
          event.basket.fold(0, (p, item) => p + (item.quantity * item.price));

      final rawResponse = await repository.createOrder(
          id: event.orderId,
          quantity: quantity.toString(),
          price: totalPrice,
          name: firstItem.name,
          imageUrl: firstItem.imageUrl,
          userId:userId,
          );

      final order = OrderModel.fromJson(rawResponse);


      _orders.add(order);
      emit(OrderState(orders: _orders));
    } catch (e, stack) {
      throw Exception(e.toString());
    }
  }

  void _onGetOrders(GetOrders event, Emitter<OrderState> emit) async {
    try {
      final userId = _getUserId();
      final rawResponse = await repository.getOrders(
          userId: userId!);

      final List<OrderModel> order =
          rawResponse.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();

      _orders = [...order];
      emit(OrderState(orders: _orders));
    } catch (e, stack) {
      throw Exception(e.toString());
    }
  }

  void _onChangePaymentStatus(
      ChangePaymentStatus event, Emitter<OrderState> emit) async {
    try {
      final userId = _getUserId();
      final rawResponse =
          await repository.changePaymentStatus(orderId: event.orderId);

      if (rawResponse != null) {
        return;
      }
    } catch (e, stack) {
      throw Exception(e.toString());
    }
  }
}

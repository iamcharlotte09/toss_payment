import 'package:bloc/bloc.dart';
import 'package:commerce_app/event/product.event.dart';
import 'package:commerce_app/model/product.model.dart';
import 'package:commerce_app/repository/product.repository.dart';
import 'package:commerce_app/state/product.state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({
    required this.repository,
  }) : super(InitialProductState()) {
    on<GetProducts>(_onGetProducts);
  }

  void _onGetProducts(GetProducts event, Emitter<ProductState> emit) async {
    emit(LoadingProductState());
    try {
      final rawResponse = await repository.getProducts();

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(rawResponse);

      final List<ProductModel> response =
          data.map((e) => ProductModel.fromJson(e)).toList();

      emit(LoadedProductState(products: response));
    } catch (e, stack) {
      print(stack);
      emit(ErrorProductState(message: "Failed to load products"));
    }
  }
}

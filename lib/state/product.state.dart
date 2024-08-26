import 'package:commerce_app/model/product.model.dart';

abstract class ProductState {}

class InitialProductState extends ProductState {}

class LoadingProductState extends ProductState {}

class LoadedProductState extends ProductState {
  final List<ProductModel> products;

  LoadedProductState({
    required this.products,
  });
}

class ErrorProductState extends ProductState {
  final String message;

  ErrorProductState({
    required this.message,
  });
}


import '../../../../domain/entities/product.dart';

abstract class ProductState {}

class InitialState extends ProductState {}

class LoadingState extends ProductState {}

class LoadedAllProductsState extends ProductState {
  final List<Product> products;

  LoadedAllProductsState(this.products);
}

class LoadedSingleProductState extends ProductState {
  final Product product;

  LoadedSingleProductState(this.product);
}

class ErrorState extends ProductState {
  final String message;

  ErrorState(this.message);
}
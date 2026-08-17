import '../../../../domain/entities/product.dart';

abstract class ProductEvent {}

class LoadAllProductsEvent extends ProductEvent {}

class GetSingleProductEvent extends ProductEvent {
  final String id;

  GetSingleProductEvent(this.id);
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  UpdateProductEvent(this.product);
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  DeleteProductEvent(this.id);
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  CreateProductEvent(this.product);
}
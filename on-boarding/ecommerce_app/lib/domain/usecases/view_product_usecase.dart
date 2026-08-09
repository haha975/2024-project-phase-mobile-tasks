import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failure.dart';
import '../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase
    extends UseCase<Product, ProductParams> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductParams params) {
    return repository.getProduct(params.id);
  }
}

class ProductParams extends Equatable {
  final String id;

  const ProductParams(this.id);

  @override
  List<Object?> get props => [id];
}
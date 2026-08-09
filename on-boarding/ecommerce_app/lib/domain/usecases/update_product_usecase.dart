import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failure.dart';
import '../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase
    extends UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(
    UpdateProductParams params,
  ) {
    return repository.updateProduct(params.product);
  }
}

class UpdateProductParams extends Equatable {
  final Product product;

  const UpdateProductParams(this.product);

  @override
  List<Object?> get props => [product];
}
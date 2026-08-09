import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failure.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase
    extends UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    DeleteProductParams params,
  ) {
    return repository.deleteProduct(params.id);
  }
}

class DeleteProductParams extends Equatable {
  final String id;

  const DeleteProductParams(this.id);

  @override
  List<Object?> get props => [id];
}
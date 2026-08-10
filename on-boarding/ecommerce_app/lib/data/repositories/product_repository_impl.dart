import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../../features/ecommerce/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getProducts();

      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final product = await remoteDataSource.getProduct(id);

      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );

      final result = await remoteDataSource.createProduct(productModel);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );

      final result = await remoteDataSource.updateProduct(productModel);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
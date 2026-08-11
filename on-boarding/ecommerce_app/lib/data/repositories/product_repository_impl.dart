import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../../features/ecommerce/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      if (await networkInfo.isConnected) {
        // Internet available → use remote data source
        final products = await remoteDataSource.getProducts();

        // Save products locally for later
        await localDataSource.cacheProducts(products);

        return Right(products);
      } else {
        // No internet → use local data source
        final products = await localDataSource.getCachedProducts();

        return Right(products);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        // Internet available → remote
        final product = await remoteDataSource.getProduct(id);

        return Right(product);
      } else {
        // No internet → local
        final product = await localDataSource.getCachedProduct(id);

        return Right(product);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(
    Product product,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
        );

        final result =
            await remoteDataSource.createProduct(productModel);

        return Right(result);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(
    Product product,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
        );

        final result =
            await remoteDataSource.updateProduct(productModel);

        return Right(result);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteProduct(id);

        return const Right(null);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
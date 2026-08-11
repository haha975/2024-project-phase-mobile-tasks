import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import '../../../../../lib/core/error/failure.dart';
import '../../../../../lib/core/network/network_info.dart';
import '../../../../../lib/data/datasources/product_local_data_source.dart';
import '../../../../../lib/data/datasources/product_remote_data_source.dart';
import '../../../../../lib/data/repositories/product_repository_impl.dart';
import '../../../../../lib/domain/entities/product.dart';
import '../../../../../lib/features/ecommerce/data/models/product_model.dart';

class FakeNetworkInfo implements NetworkInfo {
  bool connected;

  FakeNetworkInfo(this.connected);

  @override
  Future<bool> get isConnected async => connected;
}

class FakeRemoteDataSource implements ProductRemoteDataSource {
  final List<ProductModel> products = [];

  bool shouldFail = false;

  @override
  Future<List<ProductModel>> getProducts() async {
    if (shouldFail) {
      throw Exception();
    }

    return products;
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    if (shouldFail) {
      throw Exception();
    }

    return products.firstWhere((product) => product.id == id);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    if (shouldFail) {
      throw Exception();
    }

    products.add(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    if (shouldFail) {
      throw Exception();
    }

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      products[index] = product;
    }

    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (shouldFail) {
      throw Exception();
    }

    products.removeWhere(
      (product) => product.id == id,
    );
  }
}

class FakeLocalDataSource implements ProductLocalDataSource {
  List<ProductModel> cachedProducts = [];

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    cachedProducts = products;
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    return cachedProducts;
  }

  @override
  Future<ProductModel> getCachedProduct(String id) async {
    return cachedProducts.firstWhere(
      (product) => product.id == id,
    );
  }
}

void main() {
  late FakeRemoteDataSource remoteDataSource;
  late FakeLocalDataSource localDataSource;
  late FakeNetworkInfo networkInfo;
  late ProductRepositoryImpl repository;

  final product = ProductModel(
    id: '1',
    name: 'Laptop',
    description: 'Gaming laptop',
    imageUrl: 'laptop.jpg',
    price: 1000,
  );

  setUp(() {
    remoteDataSource = FakeRemoteDataSource();
    localDataSource = FakeLocalDataSource();
    networkInfo = FakeNetworkInfo(true);

    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  test('should get products from remote when connected', () async {
    remoteDataSource.products.add(product);

    final result = await repository.getAllProducts();

    expect(result.isRight(), true);
  });

  test('should get product from remote when connected', () async {
    remoteDataSource.products.add(product);

    final result = await repository.getProduct('1');

    expect(result.isRight(), true);
  });

  test('should create product using remote data source', () async {
    final result = await repository.createProduct(product);

    expect(result.isRight(), true);
    expect(remoteDataSource.products.length, 1);
  });

  test('should update product using remote data source', () async {
    remoteDataSource.products.add(product);

    final updatedProduct = ProductModel(
      id: '1',
      name: 'Updated Laptop',
      description: 'Updated description',
      imageUrl: 'updated.jpg',
      price: 1500,
    );

    final result = await repository.updateProduct(updatedProduct);

    expect(result.isRight(), true);
    expect(
      remoteDataSource.products.first.name,
      'Updated Laptop',
    );
  });

  test('should delete product using remote data source', () async {
    remoteDataSource.products.add(product);

    final result = await repository.deleteProduct('1');

    expect(result.isRight(), true);
    expect(remoteDataSource.products.isEmpty, true);
  });

  test('should return failure when remote source fails', () async {
    remoteDataSource.shouldFail = true;

    final result = await repository.getAllProducts();

    expect(result.isLeft(), true);
  });
}


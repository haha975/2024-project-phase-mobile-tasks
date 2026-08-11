import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_app/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/ecommerce/data/models/product_model.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  const product = ProductModel(
    id: '1',
    name: 'Phone',
    description: 'A smartphone',
    imageUrl: 'phone.jpg',
    price: 500,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    sharedPreferences = await SharedPreferences.getInstance();

    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  test('should cache products successfully', () async {
    await dataSource.cacheProducts([product]);

    final result = await dataSource.getCachedProducts();

    expect(result.length, 1);
    expect(result[0].id, product.id);
    expect(result[0].name, product.name);
    expect(result[0].description, product.description);
    expect(result[0].imageUrl, product.imageUrl);
    expect(result[0].price, product.price);
  });

  test('should return empty list when there are no cached products', () async {
    final result = await dataSource.getCachedProducts();

    expect(result, isEmpty);
  });

  test('should return cached product by id', () async {
    await dataSource.cacheProducts([product]);

    final result = await dataSource.getCachedProduct('1');

    expect(result.id, product.id);
    expect(result.name, product.name);
    expect(result.description, product.description);
    expect(result.imageUrl, product.imageUrl);
    expect(result.price, product.price);
  });
}




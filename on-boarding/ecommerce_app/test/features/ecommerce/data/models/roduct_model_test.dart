import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app/features/ecommerce/data/models/product_model.dart';

void main() {
  const testJson = {
    'id': '1',
    'name': 'Laptop',
    'description': 'Gaming laptop',
    'imageUrl': 'https://example.com/laptop.jpg',
    'price': 1200,
  };

  test('should create ProductModel from JSON', () {
    final product = ProductModel.fromJson(testJson);

    expect(product.id, '1');
    expect(product.name, 'Laptop');
    expect(product.description, 'Gaming laptop');
    expect(product.imageUrl, 'https://example.com/laptop.jpg');
    expect(product.price, 1200);
  });

  test('should convert ProductModel to JSON', () {
    const product = ProductModel(
      id: '1',
      name: 'Laptop',
      description: 'Gaming laptop',
      imageUrl: 'https://example.com/laptop.jpg',
      price: 1200,
    );

    final json = product.toJson();

    expect(json, testJson);
  });
}
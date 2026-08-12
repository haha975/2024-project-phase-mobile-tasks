import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:ecommerce_app/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/ecommerce/data/models/product_model.dart';

import 'mock_http_client.mocks.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  const product = ProductModel(
    id: '1',
    name: 'Phone',
    description: 'A smartphone',
    imageUrl: 'phone.jpg',
    price: 500,
  );

  setUp(() {
    mockClient = MockClient();

    dataSource = ProductRemoteDataSourceImpl(
      client: mockClient,
    );
  });

  // --------------------------------------------------
  // TEST 1: getProducts()
  // --------------------------------------------------

  test('should return list of products when API returns 200', () async {
    final responseBody = jsonEncode({
      'statusCode': 200,
      'message': '',
      'data': [
        {
          'id': '1',
          'name': 'Phone',
          'description': 'A smartphone',
          'price': 500,
          'imageUrl': 'phone.jpg',
        },
      ],
    });

    when(mockClient.get(any)).thenAnswer(
      (_) async => http.Response(responseBody, 200),
    );

    final result = await dataSource.getProducts();

    expect(result.length, 1);
    expect(result[0].id, product.id);
    expect(result[0].name, product.name);
    expect(result[0].description, product.description);
    expect(result[0].price, product.price);
    expect(result[0].imageUrl, product.imageUrl);
  });

  // --------------------------------------------------
  // TEST 2: getProduct()
  // --------------------------------------------------

  test('should return a single product when API returns 200', () async {
    final responseBody = jsonEncode({
      'statusCode': 200,
      'message': '',
      'data': {
        'id': '1',
        'name': 'Phone',
        'description': 'A smartphone',
        'price': 500,
        'imageUrl': 'phone.jpg',
      },
    });

    when(mockClient.get(any)).thenAnswer(
      (_) async => http.Response(responseBody, 200),
    );

    final result = await dataSource.getProduct('1');

    expect(result.id, '1');
    expect(result.name, 'Phone');
    expect(result.description, 'A smartphone');
    expect(result.price, 500);
    expect(result.imageUrl, 'phone.jpg');
  });

  // --------------------------------------------------
  // TEST 3: createProduct()
  // --------------------------------------------------

  test('should create product when API returns 201', () async {
    final responseBody = jsonEncode({
      'statusCode': 201,
      'message': '',
      'data': {
        'id': '1',
        'name': 'Phone',
        'description': 'A smartphone',
        'price': 500,
        'imageUrl': 'phone.jpg',
      },
    });

    when(mockClient.send(any)).thenAnswer(
      (_) async => http.StreamedResponse(
        Stream.fromIterable([
          utf8.encode(responseBody),
        ]),
        201,
      ),
    );

    final result = await dataSource.createProduct(product);

    expect(result.id, product.id);
    expect(result.name, product.name);
    expect(result.description, product.description);
    expect(result.price, product.price);
    expect(result.imageUrl, product.imageUrl);
  });
  test('should update product when API returns 200', () async {
  final responseBody = jsonEncode({
    'statusCode': 200,
    'message': '',
    'data': {
      'id': '1',
      'name': 'Updated Phone',
      'description': 'Updated description',
      'price': 600,
      'imageUrl': 'phone.jpg',
    },
  });

  when(mockClient.put(
    any,
    headers: anyNamed('headers'),
    body: anyNamed('body'),
  )).thenAnswer(
    (_) async => http.Response(responseBody, 200),
  );

  final updatedProduct = ProductModel(
    id: '1',
    name: 'Updated Phone',
    description: 'Updated description',
    imageUrl: 'phone.jpg',
    price: 600,
  );

  final result = await dataSource.updateProduct(updatedProduct);

  expect(result.id, '1');
  expect(result.name, 'Updated Phone');
  expect(result.description, 'Updated description');
  expect(result.price, 600);
  expect(result.imageUrl, 'phone.jpg');
});
test('should delete product when API returns 200', () async {
  when(mockClient.delete(any)).thenAnswer(
    (_) async => http.Response(
      jsonEncode({
        'statusCode': 200,
        'message': '',
      }),
      200,
    ),
  );

  await dataSource.deleteProduct('1');

  verify(mockClient.delete(
    Uri.parse(
      '${ProductRemoteDataSourceImpl.baseUrl}/1',
    ),
  )).called(1);
});
}
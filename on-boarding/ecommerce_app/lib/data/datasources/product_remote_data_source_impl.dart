import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/ecommerce/data/models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  static const String baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body);

      final List<dynamic> data = jsonResponse['data'];

      return data
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body);

      return ProductModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl),
    );

    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();

    final streamedResponse = await client.send(request);

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body);

      return ProductModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body);

      return ProductModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
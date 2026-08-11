import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/ecommerce/data/models/product_model.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static const String cachedProductsKey = 'CACHED_PRODUCTS';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = jsonEncode(
      products.map((product) => product.toJson()).toList(),
    );

    await sharedPreferences.setString(
      cachedProductsKey,
      jsonString,
    );
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString =
        sharedPreferences.getString(cachedProductsKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map(
          (json) => ProductModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<ProductModel> getCachedProduct(String id) async {
    final products = await getCachedProducts();

    return products.firstWhere(
      (product) => product.id == id,
    );
  }
}
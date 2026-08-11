import '../../features/ecommerce/data/models/product_model.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final List<ProductModel> cachedProducts = [];

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    cachedProducts.clear();
    cachedProducts.addAll(products);
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
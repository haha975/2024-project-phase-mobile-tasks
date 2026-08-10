import '../../../features/ecommerce/data/models/product_model.dart';


abstract class ProductLocalDataSource {

  Future<List<ProductModel>> getCachedProducts();

  Future<void> saveProducts(
      List<ProductModel> products
  );

  Future<void> deleteProduct(String id);

}
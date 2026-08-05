class Product {
  String name;
  String description;
  double price;

  Product(this.name, this.description, this.price);

  void showInfo() {
    print("Name: $name");
    print("Description: $description");
    print("Price: $price");
  }
}

class ProductManager {
  List<Product> products = [];

  // Add product
  void add(Product product) {
    products.add(product);
  }

  // View all products
  void viewAll() {
    for (Product product in products) {
      product.showInfo();
      print("----------------");
    }
  }

  // View one product
  void viewOne(int index) {
    products[index].showInfo();
  }

  // Update product
  void update(int index, String newName, String newDescription, double newPrice) {
    products[index].name = newName;
    products[index].description = newDescription;
    products[index].price = newPrice;
  }

  // Delete product
  void delete(int index) {
    products.removeAt(index);
  }
}

void main() {

  ProductManager manager = ProductManager();


  Product laptop = Product(
      "Laptop",
      "Gaming laptop",
      1000
  );

  Product phone = Product(
      "Phone",
      "Samsung phone",
      500
  );


  // add products
  manager.add(laptop);
  manager.add(phone);


  // view products
  manager.viewAll();


  // update product
  manager.update(
      0,
      "MacBook",
      "Apple laptop",
      1500
  );

  // delete product
  manager.delete(1);

  print("After changes:");
  manager.viewAll();
}

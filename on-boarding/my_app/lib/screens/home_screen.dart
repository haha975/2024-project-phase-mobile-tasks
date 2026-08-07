import 'package:flutter/material.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  final List<Product> products = [
    Product(
      title: "Laptop",
      description: "Gaming laptop",
    ),
    Product(
      title: "Phone",
      description: "Android phone",
    ),
  ];


  void deleteProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Products"),
      ),


      floatingActionButton: FloatingActionButton(
  child: const Icon(Icons.add),

  onPressed: () {
    Navigator.pushNamed(
      context,
      '/addEdit',
    );
  },
),


      body: ListView.builder(

        itemCount: products.length,

        itemBuilder: (context,index){

          final product = products[index];


          return Card(

            child: ListTile(

              title: Text(product.title),

              subtitle: Text(product.description),


              onTap: () async {

                final result = await Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: product,
                );


                if(result == true){

                  deleteProduct(product);

                }

              },

            ),

          );

        },

      ),

    );

  }
}
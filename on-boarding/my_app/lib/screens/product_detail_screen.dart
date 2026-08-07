import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final product =
        ModalRoute.of(context)!.settings.arguments as Product;


    return Scaffold(

      appBar: AppBar(

        title: const Text("Product Detail"),


        actions: [

          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),

            onPressed: () {

              Navigator.pushNamed(
                context,
                '/addEdit',
                arguments: product,
              );

            },
          ),


          // Delete button
          IconButton(

            icon: const Icon(Icons.delete),


            onPressed: () {

              Navigator.pop(
                context,
                true,
              );

            },

          ),

        ],

      ),



      body: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [


            Text(

              product.title,

              style: const TextStyle(

                fontSize: 30,

                fontWeight: FontWeight.bold,

              ),

            ),



            const SizedBox(height: 20),



            Text(

              product.description,

              style: const TextStyle(

                fontSize: 18,

              ),

            ),


          ],

        ),

      ),

    );

  }
}
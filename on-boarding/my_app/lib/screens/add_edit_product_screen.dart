import 'package:flutter/material.dart';
import '../models/product.dart';


class AddEditProductScreen extends StatefulWidget {

  const AddEditProductScreen({super.key});


  @override
  State<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();

}



class _AddEditProductScreenState 
extends State<AddEditProductScreen> {


  final titleController = TextEditingController();

  final descriptionController = TextEditingController();


  Product? product;



  @override
  void didChangeDependencies() {

    super.didChangeDependencies();


    product =
        ModalRoute.of(context)!.settings.arguments as Product?;


    if(product != null){

      titleController.text = product!.title;

      descriptionController.text = product!.description;

    }

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: Text(
          product == null 
          ? "Add Product"
          : "Edit Product",
        ),
      ),



      body: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(

          children: [


            TextField(

              controller: titleController,

              decoration: const InputDecoration(
                labelText: "Title",
              ),

            ),



            TextField(

              controller: descriptionController,

              decoration: const InputDecoration(
                labelText: "Description",
              ),

            ),



            const SizedBox(height: 20),



            ElevatedButton(

              onPressed: () {

                Navigator.pop(context);

              },

              child: const Text("Save"),

            )

          ],

        ),

      ),

    );

  }
}
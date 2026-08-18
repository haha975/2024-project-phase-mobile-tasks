import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection_container.dart';
import '../../../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({
    super.key,
    this.product,
  });

  bool get isEditing => product != null;

  @override
  State<AddEditProductPage> createState() =>
      _AddEditProductPageState();
}

class _AddEditProductPageState
    extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.product?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );

    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );

    _imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
      price: double.parse(_priceController.text),
    );

    final bloc = context.read<ProductBloc>();

    if (widget.isEditing) {
      bloc.add(
        UpdateProductEvent(product),
      );
    } else {
      bloc.add(
        CreateProductEvent(product),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing
                    ? 'Edit Product'
                    : 'Add Product',
              ),
            ),

            body: BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is LoadedSingleProductState) {
                  Navigator.pop(context);
                }

                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },

              child: Form(
                key: _formKey,

                child: ListView(
                  padding: const EdgeInsets.all(16),

                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter product name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter description';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter price';
                        }

                        if (double.tryParse(value) == null) {
                          return 'Enter a valid price';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        widget.isEditing
                            ? 'Update Product'
                            : 'Create Product',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
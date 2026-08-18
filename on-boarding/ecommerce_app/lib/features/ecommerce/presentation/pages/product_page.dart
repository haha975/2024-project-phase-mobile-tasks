import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/product_card.dart';
import '../../../../core/injection_container.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(LoadAllProductsEvent()),

      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),

        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {

            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }


            if (state is ErrorState) {
              return Center(
                child: Text(state.message),
              );
            }


            if (state is LoadedAllProductsState) {

              if (state.products.isEmpty) {
                return const Center(
                  child: Text('No products'),
                );
              }


              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: state.products.length,

                itemBuilder: (context, index) {

                  final product = state.products[index];

                  return ProductCard(
                    product: product,
                  );
                },
              );
            }


            return const Center(
              child: Text('No products'),
            );
          },
        ),
      ),
    );
  }
}
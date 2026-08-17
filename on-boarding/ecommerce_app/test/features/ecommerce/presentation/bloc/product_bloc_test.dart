import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/domain/usecases/view_product_usecase.dart';
import 'package:ecommerce_app/features/ecommerce/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/ecommerce/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/features/ecommerce/presentation/bloc/product_state.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  ViewAllProductsUsecase,
  ViewProductUsecase,
  CreateProductUsecase,
  UpdateProductUsecase,
  DeleteProductUsecase,
])
void main() {
  late MockViewAllProductsUsecase mockViewAllProducts;
  late MockViewProductUsecase mockViewProduct;
  late MockCreateProductUsecase mockCreateProduct;
  late MockUpdateProductUsecase mockUpdateProduct;
  late MockDeleteProductUsecase mockDeleteProduct;

  late ProductBloc bloc;

  final product = Product(
    id: '1',
    name: 'Laptop',
    description: 'Good laptop',
    imageUrl: 'image.jpg',
    price: 1000,
  );

  setUp(() {
    mockViewAllProducts = MockViewAllProductsUsecase();
    mockViewProduct = MockViewProductUsecase();
    mockCreateProduct = MockCreateProductUsecase();
    mockUpdateProduct = MockUpdateProductUsecase();
    mockDeleteProduct = MockDeleteProductUsecase();

    bloc = ProductBloc(
      viewAllProductsUsecase: mockViewAllProducts,
      viewProductUsecase: mockViewProduct,
      createProductUsecase: mockCreateProduct,
      updateProductUsecase: mockUpdateProduct,
      deleteProductUsecase: mockDeleteProduct,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be InitialState', () {
    expect(bloc.state, isA<InitialState>());
  });

  test('LoadAllProductsEvent should emit Loading then LoadedAllProductsState',
      () async {
    when(mockViewAllProducts(any)).thenAnswer(
      (_) async => Right([product]),
    );

    bloc.add(LoadAllProductsEvent());

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state, isA<LoadedAllProductsState>());

    final state = bloc.state as LoadedAllProductsState;

    expect(state.products, [product]);
  });

  test('GetSingleProductEvent should emit LoadedSingleProductState',
      () async {
    when(mockViewProduct(ProductParams('1'))).thenAnswer(
      (_) async => Right(product),
    );

    bloc.add(GetSingleProductEvent('1'));

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state, isA<LoadedSingleProductState>());

    final state = bloc.state as LoadedSingleProductState;

    expect(state.product, product);
  });

  test('UpdateProductEvent should emit LoadedSingleProductState', () async {
    when(mockUpdateProduct(UpdateProductParams(product))).thenAnswer(
      (_) async => Right(product),
    );

    bloc.add(UpdateProductEvent(product));

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state, isA<LoadedSingleProductState>());
  });

  test('DeleteProductEvent should return to InitialState', () async {
    when(mockDeleteProduct(DeleteProductParams('1'))).thenAnswer(
      (_) async => const Right(null),
    );

    bloc.add(DeleteProductEvent('1'));

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state, isA<InitialState>());
  });

  test('CreateProductEvent should emit LoadedSingleProductState', () async {
    when(mockCreateProduct(product)).thenAnswer(
      (_) async {},
    );

    bloc.add(CreateProductEvent(product));

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state, isA<LoadedSingleProductState>());

    final state = bloc.state as LoadedSingleProductState;

    expect(state.product, product);
  });
}
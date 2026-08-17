import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../domain/usecases/create_product_usecase.dart';
import '../../../../domain/usecases/delete_product_usecase.dart';
import '../../../../domain/usecases/update_product_usecase.dart';
import '../../../../domain/usecases/view_all_products_usecase.dart';
import '../../../../domain/usecases/view_product_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUsecase viewAllProductsUsecase;
  final ViewProductUsecase viewProductUsecase;
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  ProductBloc({
    required this.viewAllProductsUsecase,
    required this.viewProductUsecase,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  }) : super(InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await viewAllProductsUsecase(NoParams());

    result.fold(
      (failure) {
        emit(ErrorState(_failureMessage(failure)));
      },
      (products) {
        emit(LoadedAllProductsState(products));
      },
    );
  }

  Future<void> _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await viewProductUsecase(
      ProductParams(event.id),
    );

    result.fold(
      (failure) {
        emit(ErrorState(_failureMessage(failure)));
      },
      (product) {
        emit(LoadedSingleProductState(product));
      },
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    try {
      await createProductUsecase(event.product);

      emit(LoadedSingleProductState(event.product));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await updateProductUsecase(
      UpdateProductParams(event.product),
    );

    result.fold(
      (failure) {
        emit(ErrorState(_failureMessage(failure)));
      },
      (product) {
        emit(LoadedSingleProductState(product));
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await deleteProductUsecase(
      DeleteProductParams(event.id),
    );

    result.fold(
      (failure) {
        emit(ErrorState(_failureMessage(failure)));
      },
      (_) {
        emit(InitialState());
      },
    );
  }

  String _failureMessage(Failure failure) {
    return failure.toString();
  }
}
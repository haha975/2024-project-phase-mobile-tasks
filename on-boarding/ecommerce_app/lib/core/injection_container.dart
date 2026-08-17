import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../features/ecommerce/presentation/bloc/product_bloc.dart';

import '../domain/repositories/product_repository.dart';
import '../domain/usecases/create_product_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart';
import '../domain/usecases/view_all_products_usecase.dart';
import '../domain/usecases/view_product_usecase.dart';

import '../data/repositories/product_repository_impl.dart';
import '../data/datasources/product_remote_data_source.dart';
import '../data/datasources/product_remote_data_source_impl.dart';
import '../data/datasources/product_local_data_source.dart';
import '../data/datasources/product_local_data_source_impl.dart';

import 'network/network_info.dart';
import 'network/network_info_impl.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  sl.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // Network
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<ViewAllProductsUsecase>(
    () => ViewAllProductsUsecase(sl()),
  );

  sl.registerLazySingleton<ViewProductUsecase>(
    () => ViewProductUsecase(sl()),
  );

  sl.registerLazySingleton<CreateProductUsecase>(
    () => CreateProductUsecase(sl()),
  );

  sl.registerLazySingleton<UpdateProductUsecase>(
    () => UpdateProductUsecase(sl()),
  );

  sl.registerLazySingleton<DeleteProductUsecase>(
    () => DeleteProductUsecase(sl()),
  );

  // BLoC
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
      viewAllProductsUsecase: sl(),
      viewProductUsecase: sl(),
      createProductUsecase: sl(),
      updateProductUsecase: sl(),
      deleteProductUsecase: sl(),
    ),
  );
}
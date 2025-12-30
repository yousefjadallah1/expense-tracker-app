import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'core/utils/secure_storage.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'features/transactions/data/repositories/transactions_repository.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => TransactionsBloc(sl()));

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(sl(), sl()));
  sl.registerLazySingleton(() => HomeRepository(sl()));
  sl.registerLazySingleton(() => TransactionsRepository(sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionsRemoteDataSource>(
    () => TransactionsRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(storage: sl()));
  sl.registerLazySingleton(() => SecureStorageService(sl()));

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}

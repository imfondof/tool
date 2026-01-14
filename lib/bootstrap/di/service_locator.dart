import 'package:get_it/get_it.dart';

import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/hive_service.dart';
import '../../core/storage/storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator(AppConfig config) async {
  getIt.registerSingleton<AppConfig>(config);
  getIt.registerLazySingleton<StorageService>(() => HiveStorageService());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt()));

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));
}

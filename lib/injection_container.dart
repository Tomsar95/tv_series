import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/features/login/data/datasources/user_local_data_source.dart';
import 'package:tv_series/features/login/domain/repositories/user_repository.dart';
import 'package:tv_series/features/login/data/repositories/user_repository_impl.dart';
import 'package:tv_series/features/login/domain/usecases/get_user.dart';
import 'package:tv_series/features/login/domain/usecases/try_to_authenticate.dart';
import 'package:tv_series/features/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:tv_series/features/series/data/datasources/series_remote_data_source.dart';
import 'package:tv_series/features/series/data/repositories/series_repository_impl.dart';
import 'package:tv_series/features/series/domain/repositories/series_repository.dart';
import 'package:tv_series/features/series/domain/use_cases/get_series.dart';
import 'package:tv_series/features/series/presentation/blocs/home_page_bloc/home_page_bloc.dart';

import 'features/core/network/network_info.dart';
import 'features/login/domain/usecases/set_user.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  initFeatures();
  // Core
  initCore();
  // External
  await initExternal();
}

void initFeatures() {
  // BLoC
  serviceLocator.registerFactory(() => LoginBloc(getUser: serviceLocator(), setUser: serviceLocator(), tryToAuthenticate: serviceLocator()));
  serviceLocator.registerFactory(() => HomePageBloc(getSeries: serviceLocator()));

  // Use Cases
  serviceLocator.registerLazySingleton(() => GetUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => TryToAuthenticate(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetSeries(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<UserRepository>(() =>
      UserRepositoryImpl(
          localDataSource: serviceLocator(),));
  serviceLocator.registerLazySingleton<SeriesRepository>(() =>
      SeriesRepositoryImpl(
        remoteDataSource: serviceLocator(),));

  // Data sources
  serviceLocator.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: serviceLocator()));
  serviceLocator.registerLazySingleton<SeriesRemoteDataSource>(
          () => SeriesRemoteDataSourceImpl(client: serviceLocator()));
}

void initCore() {
  // network info
  serviceLocator.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(serviceLocator()));
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
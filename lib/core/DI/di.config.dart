// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movie_app/core/DI/network_module.dart' as _i733;
import 'package:movie_app/data/remote/movies_api_client.dart' as _i827;
import 'package:movie_app/data/repository/auth_repository.dart' as _i257;
import 'package:movie_app/data/repository/auth_repository_impl.dart' as _i408;
import 'package:movie_app/data/repository/movies_repository.dart' as _i523;
import 'package:movie_app/data/repository/movies_repository_impl.dart' as _i872;
import 'package:movie_app/ui/browse/cubit/browse_cubit.dart' as _i342;
import 'package:movie_app/ui/home/screen/tabs/home/home_cubit.dart' as _i700;
import 'package:movie_app/ui/home/screen/tabs/search/search_cubit.dart' as _i701;
import 'package:movie_app/ui/forget_password/cubit/forget_password_cubit.dart'
    as _i520;
import 'package:movie_app/ui/login/cubit/login_cubit.dart' as _i379;
import 'package:movie_app/ui/movie_details/cubit/movie_details_cubit.dart'
    as _i551;
import 'package:movie_app/ui/register/cubit/register_cubit.dart' as _i920;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.factory<_i257.AuthRepository>(() => _i408.AuthRepositoryImpl());
    gh.factory<_i520.ForgetPasswordCubit>(
      () => _i520.ForgetPasswordCubit(gh<_i257.AuthRepository>()),
    );
    gh.factory<_i379.LoginCubit>(
      () => _i379.LoginCubit(gh<_i257.AuthRepository>()),
    );
    gh.factory<_i920.RegisterCubit>(
      () => _i920.RegisterCubit(gh<_i257.AuthRepository>()),
    );
    gh.lazySingleton<_i827.MoviesApiClient>(
      () => _i827.MoviesApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i523.MoviesRepository>(
      () => _i872.MoviesRepositoryImpl(gh<_i827.MoviesApiClient>()),
    );
    gh.factory<_i700.HomeCubit>(
      () => _i700.HomeCubit(gh<_i523.MoviesRepository>()),
    );
    gh.factory<_i701.SearchCubit>(
      () => _i701.SearchCubit(gh<_i523.MoviesRepository>()),
    );
    gh.factory<_i342.BrowseCubit>(
      () => _i342.BrowseCubit(gh<_i523.MoviesRepository>()),
    );
    gh.factory<_i551.MovieDetailsCubit>(
      () => _i551.MovieDetailsCubit(gh<_i523.MoviesRepository>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i733.NetworkModule {}

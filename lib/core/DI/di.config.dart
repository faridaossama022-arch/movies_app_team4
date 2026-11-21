// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movie_app/data/repository/auth_repository.dart' as _i257;
import 'package:movie_app/data/repository/auth_repository_impl.dart' as _i408;
import 'package:movie_app/ui/register/cubit/register_cubit.dart' as _i920;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i257.AuthRepository>(() => _i408.AuthRepositoryImpl());
    gh.factory<_i920.RegisterCubit>(
      () => _i920.RegisterCubit(gh<_i257.AuthRepository>()),
    );
    return this;
  }
}

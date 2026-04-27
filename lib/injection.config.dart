// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:advmobprog_prefinals_tp01_amarille/service/calculator_service.dart'
    as _i1011;
import 'package:advmobprog_prefinals_tp01_amarille/service/calculator_service_impl.dart'
    as _i993;
import 'package:advmobprog_prefinals_tp01_amarille/service/history_service.dart'
    as _i578;
import 'package:advmobprog_prefinals_tp01_amarille/service/history_service_impl.dart'
    as _i924;
import 'package:advmobprog_prefinals_tp01_amarille/service/math_engine.dart'
    as _i947;
import 'package:advmobprog_prefinals_tp01_amarille/service/math_engine_impl.dart'
    as _i528;
import 'package:advmobprog_prefinals_tp01_amarille/service/platform_hardware_service.dart'
    as _i963;
import 'package:advmobprog_prefinals_tp01_amarille/service/platform_hardware_service_impl.dart'
    as _i934;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i963.PlatformHardwareService>(
      () => _i934.PlatformHardwareServiceImpl(),
    );
    gh.lazySingleton<_i947.MathEngine>(() => _i528.MathEngineImpl());
    gh.lazySingleton<_i578.HistoryService>(
      () => _i924.HistoryServiceImpl(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1011.CalculatorService>(
      () => _i993.CalculatorServiceImpl(
        gh<_i947.MathEngine>(),
        gh<_i578.HistoryService>(),
        gh<_i963.PlatformHardwareService>(),
      ),
    );
    return this;
  }
}

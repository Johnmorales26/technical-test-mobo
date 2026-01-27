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
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/reports/data/datasources/local/database_helper.dart'
    as _i605;
import '../../features/reports/data/repositories/report_repository_impl.dart'
    as _i246;
import '../../features/reports/domain/repositories/report_repository.dart'
    as _i939;
import '../../features/reports/domain/usecases/create_report.dart' as _i926;
import '../../features/reports/domain/usecases/get_reports.dart' as _i51;
import '../../features/reports/domain/usecases/update_report.dart' as _i728;
import '../../features/reports/presentation/bloc/report_bloc.dart' as _i652;
import '../network/network_module.dart' as _i200;
import '../router/router_module.dart' as _i948;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final routerModule = _$RouterModule();
    final networkModule = _$NetworkModule();
    gh.singleton<_i583.GoRouter>(() => routerModule.router);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i605.DatabaseHelper>(() => _i605.DatabaseHelper());
    gh.lazySingleton<_i939.IReportRepository>(
      () => _i246.ReportRepositoryImpl(gh<_i605.DatabaseHelper>()),
    );
    gh.lazySingleton<_i926.CreateReport>(
      () => _i926.CreateReport(gh<_i939.IReportRepository>()),
    );
    gh.lazySingleton<_i51.GetReports>(
      () => _i51.GetReports(gh<_i939.IReportRepository>()),
    );
    gh.lazySingleton<_i728.UpdateReport>(
      () => _i728.UpdateReport(gh<_i939.IReportRepository>()),
    );
    gh.factory<_i652.ReportBloc>(
      () => _i652.ReportBloc(
        getReports: gh<_i51.GetReports>(),
        createReport: gh<_i926.CreateReport>(),
      ),
    );
    return this;
  }
}

class _$RouterModule extends _i948.RouterModule {}

class _$NetworkModule extends _i200.NetworkModule {}

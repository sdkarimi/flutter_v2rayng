import 'package:flutter_v2y/common/http_client.dart';
import 'package:flutter_v2y/data/Appinfo.dart';
import 'package:flutter_v2y/data/source/app_data_source.dart';


final appRepository = AppRepository(AppRemoteDataSource(httpClient));

abstract class IAppRepository {
  Future<AppInfo> getInfo();
}

class AppRepository implements IAppRepository {
  final IAppDataSource dataSource;

  AppRepository(this.dataSource);

  @override
  Future<AppInfo> getInfo() => dataSource.getInfo();

}

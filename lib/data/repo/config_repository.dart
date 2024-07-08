import 'package:flutter_v2y/common/http_client.dart';
import 'package:flutter_v2y/data/source/config_data_source.dart';

final configRepository = ConfigRepository(ConfigRemoteDataSource(httpClient));

abstract class IConfigRepository {
  Future<List<dynamic>> getAll();
}

class ConfigRepository implements IConfigRepository {
  final IConfigDataSource dataSource;

  ConfigRepository(this.dataSource);

  @override
  Future<List<dynamic>> getAll() => dataSource.getAll();

}

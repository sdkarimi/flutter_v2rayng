import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Server extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final int? ping;

  Server(this.url, [this.ping = 0]);

  Server copyWith({String? url, int? ping}) {
    return Server(
      url ?? this.url,
      ping ?? this.ping,
    );
  }
}
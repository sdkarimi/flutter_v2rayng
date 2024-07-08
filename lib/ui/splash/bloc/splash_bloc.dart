import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_v2y/common/exceptions.dart';
import 'package:flutter_v2y/common/data.dart';
import 'package:flutter_v2y/common/utils.dart';
import 'package:flutter_v2y/data/Appinfo.dart';
import 'package:flutter_v2y/data/repo/app_repository.dart';
import 'package:flutter_v2y/data/repo/config_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'splash_event.dart';
part 'splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IAppRepository appRepository;
  final IConfigRepository configRepository;

  SplashBloc({required this.appRepository, required this.configRepository})
      : super(SplashLoading()) {
    on<SplashEvent>((event, emit) async {
      if (event is SplashStarted) {
        try {
          final getInfo = await appRepository.getInfo();
          final servers = await configRepository.getAll();

          final box=Hive.box<Server>(serverBoxName);
          for (final server in servers) {
            if (box.values.any((s) => s.url == server) == false) {
              final srv=Server(server);
              box.add(srv);
            }
          }
          if (box.length > 100) {
            final oldestServers = box.values.toList().sublist(0, 50);
            for (final server in oldestServers) {
              await server.delete();
            }
          }

          emit(SplashSuccess(getInfo, servers));
        } catch (e) {
          print(e);
          emit(SplashError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
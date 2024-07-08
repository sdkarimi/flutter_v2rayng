import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_v2y/common/exceptions.dart';
import 'package:flutter_v2y/data/repo/config_repository.dart';

part 'home_event.dart';
part 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IConfigRepository configRepository;
  HomeBloc({required this.configRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          if (event is ClickButtonConnected) {
            emit(HomeLoading());
          }else if(event is ClickButtonServer || event is ClickButtonRefresh){
            final servers=await configRepository.getAll();
            emit(HomeSuccess(servers));
          }



        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}

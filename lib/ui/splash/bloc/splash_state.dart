part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object> get props => [];
}



class SplashLoading extends SplashState{}

class SplashError extends SplashState {
  final AppException exception;

  const SplashError({required this.exception});
  @override
  List<Object> get props => [exception];
}

class SplashSuccess extends SplashState {
  final AppInfo info;
  final List servers;
  const SplashSuccess(this.info, this.servers);
}


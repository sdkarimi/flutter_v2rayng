part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {

  @override
  List<Object> get props => [];
  const SplashEvent();
}

class SplashStarted extends SplashEvent {

}


part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final AppException exception;

  const HomeError({required this.exception});

  @override
  List<Object> get props => [exception];
}

class HomeSuccess extends HomeState {
  final List<dynamic> servers;

  const HomeSuccess(this.servers);
}



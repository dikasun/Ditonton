import 'package:equatable/equatable.dart';

abstract class MovieState extends Equatable {
  const MovieState();
}

class MovieLoadingState extends MovieState {
  @override
  List<Object> get props => [];
}

class MovieEmptyState extends MovieState {
  @override
  List<Object> get props => [];
}

class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieHasDataState extends MovieState {
  final dynamic result;

  MovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

class MovieSuccessState extends MovieState {
  final dynamic result;

  MovieSuccessState({required this.result});

  @override
  List<Object> get props => [result];
}

class MovieWatchlistStatusState extends MovieState {
  final bool status;

  MovieWatchlistStatusState({required this.status});

  @override
  List<Object> get props => [status];
}

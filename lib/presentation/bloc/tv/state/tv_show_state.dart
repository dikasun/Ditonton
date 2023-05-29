import 'package:equatable/equatable.dart';

abstract class TVShowState extends Equatable {
  const TVShowState();
}

class TVShowLoadingState extends TVShowState {
  @override
  List<Object> get props => [];
}

class TVShowEmptyState extends TVShowState {
  @override
  List<Object> get props => [];
}

class TVShowErrorState extends TVShowState {
  final String message;

  TVShowErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TVShowHasDataState extends TVShowState {
  final dynamic result;

  TVShowHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

class TVShowSuccessState extends TVShowState {
  final dynamic result;

  TVShowSuccessState({required this.result});

  @override
  List<Object> get props => [result];
}

class TVShowWatchlistStatusState extends TVShowState {
  final bool status;

  TVShowWatchlistStatusState({required this.status});

  @override
  List<Object> get props => [status];
}

import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie/movie_detail.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class MovieNowPlayingEvent extends MovieEvent {
  @override
  List<Object> get props => [];
}

class MoviePopularEvent extends MovieEvent {
  @override
  List<Object> get props => [];
}

class MovieTopRatedEvent extends MovieEvent {
  @override
  List<Object> get props => [];
}

class MovieDetailEvent extends MovieEvent {
  final int movieId;

  MovieDetailEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieRecommendationEvent extends MovieEvent {
  final int movieId;

  MovieRecommendationEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieSearchEvent extends MovieEvent {
  final String query;

  MovieSearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class MovieGetWatchlistEvent extends MovieEvent {
  @override
  List<Object> get props => [];
}

class MovieGetWatchlistStatusEvent extends MovieEvent {
  final int movieId;

  MovieGetWatchlistStatusEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieAddWatchlistEvent extends MovieEvent {
  final MovieDetail movie;

  MovieAddWatchlistEvent({required this.movie});

  @override
  List<Object> get props => [movie];
}

class MovieRemoveWatchlistEvent extends MovieEvent {
  final MovieDetail movie;

  MovieRemoveWatchlistEvent({required this.movie});

  @override
  List<Object> get props => [movie];
}

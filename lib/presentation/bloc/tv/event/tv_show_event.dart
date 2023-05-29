import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv/tv_detail.dart';

abstract class TVShowEvent extends Equatable {
  const TVShowEvent();
}

class TVShowNowPlayingEvent extends TVShowEvent {
  @override
  List<Object> get props => [];
}

class TVShowPopularEvent extends TVShowEvent {
  @override
  List<Object> get props => [];
}

class TVShowTopRatedEvent extends TVShowEvent {
  @override
  List<Object> get props => [];
}

class TVShowDetailEvent extends TVShowEvent {
  final int tvShowId;

  TVShowDetailEvent({required this.tvShowId});

  @override
  List<Object> get props => [tvShowId];
}

class TVShowRecommendationEvent extends TVShowEvent {
  final int tvShowId;

  TVShowRecommendationEvent({required this.tvShowId});

  @override
  List<Object> get props => [tvShowId];
}

class TVShowSearchEvent extends TVShowEvent {
  final String query;

  TVShowSearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class TVShowGetWatchlistEvent extends TVShowEvent {
  @override
  List<Object> get props => [];
}

class TVShowGetWatchlistStatusEvent extends TVShowEvent {
  final int tvShowId;

  TVShowGetWatchlistStatusEvent({required this.tvShowId});

  @override
  List<Object> get props => [tvShowId];
}

class TVShowAddWatchlistEvent extends TVShowEvent {
  final TVDetail tvShow;

  TVShowAddWatchlistEvent({required this.tvShow});

  @override
  List<Object> get props => [tvShow];
}

class TVShowRemoveWatchlistEvent extends TVShowEvent {
  final TVDetail tvShow;

  TVShowRemoveWatchlistEvent({required this.tvShow});

  @override
  List<Object> get props => [tvShow];
}

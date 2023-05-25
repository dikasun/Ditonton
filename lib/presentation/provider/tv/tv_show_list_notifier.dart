import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/tv/get_now_playing_tv_show.dart';
import '../../../domain/usecases/tv/get_popular_tv_show.dart';
import '../../../domain/usecases/tv/get_top_rated_tv_show.dart';

class TVShowListNotifier extends ChangeNotifier {
  var _nowPlayingTVShows = <TV>[];

  List<TV> get nowPlayingTVShows => _nowPlayingTVShows;

  RequestState _nowPlayingState = RequestState.Empty;

  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTVShows = <TV>[];

  List<TV> get popularTVShows => _popularTVShows;

  RequestState _popularTVShowsState = RequestState.Empty;

  RequestState get popularTVShowsState => _popularTVShowsState;

  var _topRatedTVShows = <TV>[];

  List<TV> get topRatedTVShows => _topRatedTVShows;

  RequestState _topRatedTVShowsState = RequestState.Empty;

  RequestState get topRatedTVShowsState => _topRatedTVShowsState;

  String _message = '';

  String get message => _message;

  TVShowListNotifier({
    required this.getNowPlayingTVShows,
    required this.getPopularTVShows,
    required this.getTopRatedTVShows,
  });

  final GetNowPlayingTVShows getNowPlayingTVShows;
  final GetPopularTVShows getPopularTVShows;
  final GetTopRatedTVShows getTopRatedTVShows;

  Future<void> fetchNowPlayingTVShows() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTVShowsState = RequestState.Loaded;
        _popularTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVShows() async {
    _topRatedTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold(
      (failure) {
        _topRatedTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _topRatedTVShowsState = RequestState.Loaded;
        _topRatedTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}

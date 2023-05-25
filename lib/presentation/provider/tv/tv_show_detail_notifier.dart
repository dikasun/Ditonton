import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_tv_show_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_show_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVShowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVShowDetail getTVShowDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  final GetTVShowWatchListStatus getTVShowWatchListStatus;
  final SaveTVShowWatchlist saveTVShowWatchlist;
  final RemoveTVShowWatchlist removeTVShowWatchlist;

  TVShowDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowRecommendations,
    required this.getTVShowWatchListStatus,
    required this.saveTVShowWatchlist,
    required this.removeTVShowWatchlist,
  });

  late TVDetail _tvShow;

  TVDetail get tvShow => _tvShow;

  RequestState _tvShowState = RequestState.Empty;

  RequestState get tvShowState => _tvShowState;

  List<TV> _tvShowRecommendations = [];

  List<TV> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;

  RequestState get recommendationState => _recommendationState;

  String _message = '';

  String get message => _message;

  bool _isAddedToWatchlist = false;

  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTVShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShow) {
        _recommendationState = RequestState.Loading;
        _tvShow = tvShow;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvShows) {
            _recommendationState = RequestState.Loaded;
            _tvShowRecommendations = tvShows;
          },
        );
        _tvShowState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVDetail tvShow) async {
    final result = await saveTVShowWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TVDetail tvShow) async {
    final result = await removeTVShowWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getTVShowWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}

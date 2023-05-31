import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/tv/get_tv_show_watchlist_status.dart';
import '../../../domain/usecases/tv/get_watchlist_tv_show.dart';
import '../../../domain/usecases/tv/remove_tv_show_watchlist.dart';
import '../../../domain/usecases/tv/save_tv_show_watchlist.dart';
import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowWatchlistBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetWatchlistTVShows _getWatchlistTVShows;
  final GetTVShowWatchListStatus _getTVShowWatchListStatus;
  final SaveTVShowWatchlist _saveTVShowWatchlist;
  final RemoveTVShowWatchlist _removeTVShowWatchlist;

  bool watchlistStatus = false;

  TVShowWatchlistBloc(
    this._getWatchlistTVShows,
    this._getTVShowWatchListStatus,
    this._saveTVShowWatchlist,
    this._removeTVShowWatchlist,
  ) : super(TVShowEmptyState()) {
    on<TVShowGetWatchlistEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getWatchlistTVShows.execute();
      result.fold(
        (failure) {
          emit(TVShowErrorState(message: failure.message));
        },
        (tvShowsData) {
          if (tvShowsData.isEmpty) {
            emit(TVShowEmptyState());
          } else {
            emit(TVShowHasDataState(result: tvShowsData));
          }
        },
      );
    });

    on<TVShowGetWatchlistStatusEvent>((event, emit) async {
      final result = await _getTVShowWatchListStatus.execute(event.tvShowId);
      watchlistStatus = result;
      emit(TVShowWatchlistStatusState(status: result));
    });

    on<TVShowAddWatchlistEvent>((event, emit) async {
      final result = await _saveTVShowWatchlist.execute(event.tvShow);
      result.fold(
        (failure) {
          emit(TVShowErrorState(message: failure.message));
        },
        (tvShowsData) {
          emit(TVShowSuccessState(result: tvShowsData));
        },
      );
    });

    on<TVShowRemoveWatchlistEvent>((event, emit) async {
      final result = await _removeTVShowWatchlist.execute(event.tvShow);
      result.fold(
        (failure) {
          emit(TVShowErrorState(message: failure.message));
        },
        (tvShowsData) {
          emit(TVShowSuccessState(result: tvShowsData));
        },
      );
    });
  }
}

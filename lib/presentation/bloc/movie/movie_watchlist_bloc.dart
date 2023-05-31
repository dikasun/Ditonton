import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/movie/get_movie_watchlist_status.dart';
import '../../../domain/usecases/movie/get_watchlist_movies.dart';
import '../../../domain/usecases/movie/remove_movie_watchlist.dart';
import '../../../domain/usecases/movie/save_movie_watchlist.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieWatchlistBloc extends Bloc<MovieEvent, MovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetMovieWatchListStatus _getMovieWatchListStatus;
  final SaveMovieWatchlist _saveMovieWatchlist;
  final RemoveMovieWatchlist _removeMovieWatchlist;

  bool watchlistStatus = false;

  MovieWatchlistBloc(
    this._getWatchlistMovies,
    this._getMovieWatchListStatus,
    this._saveMovieWatchlist,
    this._removeMovieWatchlist,
  ) : super(MovieEmptyState()) {
    on<MovieGetWatchlistEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getWatchlistMovies.execute();
      result.fold(
        (failure) {
          emit(MovieErrorState(message: failure.message));
        },
        (moviesData) {
          if (moviesData.isEmpty) {
            emit(MovieEmptyState());
          } else {
            emit(MovieHasDataState(result: moviesData));
          }
        },
      );
    });

    on<MovieGetWatchlistStatusEvent>((event, emit) async {
      final result = await _getMovieWatchListStatus.execute(event.movieId);
      watchlistStatus = result;
      emit(MovieWatchlistStatusState(status: result));
    });

    on<MovieAddWatchlistEvent>((event, emit) async {
      final result = await _saveMovieWatchlist.execute(event.movie);
      result.fold(
        (failure) {
          emit(MovieErrorState(message: failure.message));
        },
        (moviesData) {
          emit(MovieSuccessState(result: moviesData));
        },
      );
    });

    on<MovieRemoveWatchlistEvent>((event, emit) async {
      final result = await _removeMovieWatchlist.execute(event.movie);
      result.fold(
        (failure) {
          emit(MovieErrorState(message: failure.message));
        },
        (moviesData) {
          emit(MovieSuccessState(result: moviesData));
        },
      );
    });
  }
}

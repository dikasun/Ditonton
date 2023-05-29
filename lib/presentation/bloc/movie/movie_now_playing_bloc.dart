import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/movie/get_now_playing_movies.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieNowPlayingBloc(this._getNowPlayingMovies) : super(MovieEmptyState()) {
    on<MovieNowPlayingEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getNowPlayingMovies.execute();
      result.fold(
        (failure) {
          emit(MovieErrorState(message: failure.message));
        },
        (moviesData) {
          emit(MovieHasDataState(result: moviesData));
        },
      );
    });
  }
}

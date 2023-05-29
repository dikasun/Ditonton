import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/movie/get_popular_movies.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MoviePopularBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;

  MoviePopularBloc(this._getPopularMovies) : super(MovieEmptyState()) {
    on<MoviePopularEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getPopularMovies.execute();
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

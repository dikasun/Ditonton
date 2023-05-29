import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/movie/get_top_rated_movies.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieTopRatedBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  MovieTopRatedBloc(this._getTopRatedMovies) : super(MovieEmptyState()) {
    on<MovieTopRatedEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getTopRatedMovies.execute();
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

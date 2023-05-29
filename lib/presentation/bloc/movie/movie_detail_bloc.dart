import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/movie/get_movie_detail.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieDetailBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieEmptyState()) {
    on<MovieDetailEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getMovieDetail.execute(event.movieId);
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

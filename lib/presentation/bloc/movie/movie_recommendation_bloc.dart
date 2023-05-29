import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/movie/get_movie_recommendations.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieRecommendationBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations)
      : super(MovieEmptyState()) {
    on<MovieRecommendationEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _getMovieRecommendations.execute(event.movieId);
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

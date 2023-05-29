import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/usecases/movie/search_movies.dart';
import 'event/movie_event.dart';
import 'state/movie_state.dart';

class MovieSearchBloc extends Bloc<MovieEvent, MovieState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(MovieEmptyState()) {
    on<MovieSearchEvent>((event, emit) async {
      emit(MovieLoadingState());
      final result = await _searchMovies.execute(event.query);
      result.fold(
        (failure) {
          emit(MovieErrorState(message: failure.message));
        },
        (moviesData) {
          emit(MovieHasDataState(result: moviesData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

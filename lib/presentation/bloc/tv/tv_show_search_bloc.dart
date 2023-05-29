import 'package:ditonton/domain/usecases/tv/search_tv_show.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowSearchBloc extends Bloc<TVShowEvent, TVShowState> {
  final SearchTVShows _searchTVShows;

  TVShowSearchBloc(this._searchTVShows) : super(TVShowEmptyState()) {
    on<TVShowSearchEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _searchTVShows.execute(event.query);
      result.fold(
        (failure) {
          emit(TVShowErrorState(message: failure.message));
        },
        (tvShowsData) {
          emit(TVShowHasDataState(result: tvShowsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

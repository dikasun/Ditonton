import 'package:ditonton/domain/usecases/tv/get_popular_tv_show.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowPopularBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetPopularTVShows _getPopularTVShows;

  TVShowPopularBloc(this._getPopularTVShows) : super(TVShowEmptyState()) {
    on<TVShowPopularEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getPopularTVShows.execute();
      result.fold(
        (failure) {
          emit(TVShowErrorState(message: failure.message));
        },
        (tvShowsData) {
          emit(TVShowHasDataState(result: tvShowsData));
        },
      );
    });
  }
}

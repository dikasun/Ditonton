import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_show.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowTopRatedBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetTopRatedTVShows _getTopRatedTVShows;

  TVShowTopRatedBloc(this._getTopRatedTVShows) : super(TVShowEmptyState()) {
    on<TVShowTopRatedEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getTopRatedTVShows.execute();
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

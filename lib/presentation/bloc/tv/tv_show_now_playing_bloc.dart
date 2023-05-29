import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowNowPlayingBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetNowPlayingTVShows _getNowPlayingTVShows;

  TVShowNowPlayingBloc(this._getNowPlayingTVShows) : super(TVShowEmptyState()) {
    on<TVShowNowPlayingEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getNowPlayingTVShows.execute();
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

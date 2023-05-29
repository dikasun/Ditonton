import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowDetailBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetTVShowDetail _getTVShowDetail;

  TVShowDetailBloc(this._getTVShowDetail) : super(TVShowEmptyState()) {
    on<TVShowDetailEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getTVShowDetail.execute(event.tvShowId);
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

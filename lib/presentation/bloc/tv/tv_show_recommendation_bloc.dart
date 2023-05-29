import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event/tv_show_event.dart';
import 'state/tv_show_state.dart';

class TVShowRecommendationBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetTVShowRecommendations _getTVShowRecommendations;

  TVShowRecommendationBloc(this._getTVShowRecommendations)
      : super(TVShowEmptyState()) {
    on<TVShowRecommendationEvent>((event, emit) async {
      emit(TVShowLoadingState());
      final result = await _getTVShowRecommendations.execute(event.tvShowId);
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

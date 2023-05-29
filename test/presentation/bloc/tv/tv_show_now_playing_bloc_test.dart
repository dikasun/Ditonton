import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/state/tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVShows])
void main() {
  late TVShowNowPlayingBloc tvShowNowPlayingBloc;
  late MockGetNowPlayingTVShows mockGetNowPlayingTVShows;

  setUp(() {
    mockGetNowPlayingTVShows = MockGetNowPlayingTVShows();
    tvShowNowPlayingBloc = TVShowNowPlayingBloc(mockGetNowPlayingTVShows);
  });

  final tTV = TV(
    adult: false,
    backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
    genreIds: [18, 80],
    id: 1396,
    originCountry: ["US"],
    originalLanguage: "en",
    originalTitle: "Breaking Bad",
    overview:
        "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
    popularity: 288.187,
    posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
    title: "Breaking Bad",
    voteAverage: 8.9,
    voteCount: 11696,
  );
  final tTVList = [tTV];

  test('initial state should be empty', () {
    expect(tvShowNowPlayingBloc.state, TVShowEmptyState());
  });

  blocTest<TVShowNowPlayingBloc, TVShowState>(
    'Should emit [Loading, Error] when get now playing is unsuccessful',
    build: () {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvShowNowPlayingBloc;
    },
    act: (bloc) => bloc.add(TVShowNowPlayingEvent()),
    expect: () => [
      TVShowLoadingState(),
      TVShowErrorState(message: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTVShows.execute());
    },
  );

  blocTest<TVShowNowPlayingBloc, TVShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      return tvShowNowPlayingBloc;
    },
    act: (bloc) => bloc.add(TVShowNowPlayingEvent()),
    expect: () => [
      TVShowLoadingState(),
      TVShowHasDataState(result: tTVList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTVShows.execute());
    },
  );
}

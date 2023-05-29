import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/state/tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTVShows])
void main() {
  late TVShowSearchBloc tvShowSearchBloc;
  late MockSearchTVShows mockSearchTVShows;

  setUp(() {
    mockSearchTVShows = MockSearchTVShows();
    tvShowSearchBloc = TVShowSearchBloc(mockSearchTVShows);
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
  final tQuery = 'breaking bad';

  test('initial state should be empty', () {
    expect(tvShowSearchBloc.state, TVShowEmptyState());
  });

  blocTest<TVShowSearchBloc, TVShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvShowSearchBloc;
    },
    act: (bloc) => bloc.add(TVShowSearchEvent(query: tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVShowLoadingState(),
      TVShowErrorState(message: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTVShows.execute(tQuery));
    },
  );

  blocTest<TVShowSearchBloc, TVShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      return tvShowSearchBloc;
    },
    act: (bloc) => bloc.add(TVShowSearchEvent(query: tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVShowLoadingState(),
      TVShowHasDataState(result: tTVList),
    ],
    verify: (bloc) {
      verify(mockSearchTVShows.execute(tQuery));
    },
  );
}

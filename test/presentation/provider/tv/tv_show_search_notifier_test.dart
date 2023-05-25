import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_show.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_search_notifier_test.mocks.dart';

@GenerateMocks([
  SearchTVShows,
])
void main() {
  late TVShowSearchNotifier provider;
  late MockSearchTVShows mockSearchTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVShows = MockSearchTVShows();
    provider = TVShowSearchNotifier(searchTVShows: mockSearchTVShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVShowModel = TV(
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
  final tTVShowList = <TV>[tTVShowModel];
  final tQuery = 'spiderman';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () async {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVShowList));
      provider.fetchTVShowSearch(tQuery);
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVShowList));
      await provider.fetchTVShowSearch(tQuery);
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchTVShowSearch(tQuery);
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

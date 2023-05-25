import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_show.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_show_notifier_test.mocks.dart';
import 'popular_tv_show_notifier_test.mocks.dart';
import 'top_rated_tv_show_notifier_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTVShows,
  GetPopularTVShows,
  GetTopRatedTVShows,
])
void main() {
  late TVShowListNotifier provider;
  late MockGetNowPlayingTVShows mockGetNowPlayingTVShows;
  late MockGetPopularTVShows mockGetPopularTVShows;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVShows = MockGetNowPlayingTVShows();
    mockGetPopularTVShows = MockGetPopularTVShows();
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    provider = TVShowListNotifier(
      getNowPlayingTVShows: mockGetNowPlayingTVShows,
      getPopularTVShows: mockGetPopularTVShows,
      getTopRatedTVShows: mockGetTopRatedTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVShow = TV(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: [
      "originCountry",
    ],
    originalLanguage: "originalLanguage",
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVShowList = <TV>[tTVShow];

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      provider.fetchNowPlayingTVShows();
      verify(mockGetNowPlayingTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      provider.fetchNowPlayingTVShows();
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      await provider.fetchNowPlayingTVShows();
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTVShows, tTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchNowPlayingTVShows();
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      provider.fetchPopularTVShows();
      expect(provider.popularTVShowsState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      await provider.fetchPopularTVShows();
      expect(provider.popularTVShowsState, RequestState.Loaded);
      expect(provider.popularTVShows, tTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchPopularTVShows();
      expect(provider.popularTVShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      provider.fetchTopRatedTVShows();
      expect(provider.topRatedTVShowsState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowList));
      await provider.fetchTopRatedTVShows();
      expect(provider.topRatedTVShowsState, RequestState.Loaded);
      expect(provider.topRatedTVShows, tTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchTopRatedTVShows();
      expect(provider.topRatedTVShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

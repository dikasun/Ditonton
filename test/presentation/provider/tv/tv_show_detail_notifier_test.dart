import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_tv_show_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_show_watchlist.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
  GetTVShowWatchListStatus,
  SaveTVShowWatchlist,
  RemoveTVShowWatchlist
])
void main() {
  late TVShowDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late MockGetTVShowWatchListStatus mockGetTVShowWatchlistStatus;
  late MockSaveTVShowWatchlist mockSaveTVShowWatchlist;
  late MockRemoveTVShowWatchlist mockRemoveTVShowWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    mockGetTVShowWatchlistStatus = MockGetTVShowWatchListStatus();
    mockSaveTVShowWatchlist = MockSaveTVShowWatchlist();
    mockRemoveTVShowWatchlist = MockRemoveTVShowWatchlist();
    provider = TVShowDetailNotifier(
      getTVShowDetail: mockGetTVShowDetail,
      getTVShowRecommendations: mockGetTVShowRecommendations,
      getTVShowWatchListStatus: mockGetTVShowWatchlistStatus,
      saveTVShowWatchlist: mockSaveTVShowWatchlist,
      removeTVShowWatchlist: mockRemoveTVShowWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

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
    title: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVShows = <TV>[tTVShow];

  void _arrangeUsecase() {
    when(mockGetTVShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVDetail));
    when(mockGetTVShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVShows));
  }

  group('Get TV Show Detail', () {
    test('should get data from the usecase', () async {
      _arrangeUsecase();
      await provider.fetchTVShowDetail(tId);
      verify(mockGetTVShowDetail.execute(tId));
      verify(mockGetTVShowRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      _arrangeUsecase();
      provider.fetchTVShowDetail(tId);
      expect(provider.tvShowState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv show when data is gotten successfully', () async {
      _arrangeUsecase();
      await provider.fetchTVShowDetail(tId);
      expect(provider.tvShowState, RequestState.Loaded);
      expect(provider.tvShow, testTVDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation tv shows when data is gotten successfully',
        () async {
      _arrangeUsecase();
      await provider.fetchTVShowDetail(tId);
      expect(provider.tvShowState, RequestState.Loaded);
      expect(provider.tvShowRecommendations, tTVShows);
    });
  });

  group('Get TV Show Recommendations', () {
    test('should get data from the usecase', () async {
      _arrangeUsecase();
      await provider.fetchTVShowDetail(tId);
      verify(mockGetTVShowRecommendations.execute(tId));
      expect(provider.tvShowRecommendations, tTVShows);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      _arrangeUsecase();
      await provider.fetchTVShowDetail(tId);
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvShowRecommendations, tTVShows);
    });

    test('should update error message when request in successful', () async {
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      await provider.fetchTVShowDetail(tId);
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetTVShowWatchlistStatus.execute(1))
          .thenAnswer((_) async => true);
      await provider.loadWatchlistStatus(1);
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveTVShowWatchlist.execute(testTVDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetTVShowWatchlistStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      await provider.addWatchlist(testTVDetail);
      verify(mockSaveTVShowWatchlist.execute(testTVDetail));
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveTVShowWatchlist.execute(testTVDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetTVShowWatchlistStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      await provider.removeFromWatchlist(testTVDetail);
      verify(mockRemoveTVShowWatchlist.execute(testTVDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      when(mockSaveTVShowWatchlist.execute(testTVDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetTVShowWatchlistStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      await provider.addWatchlist(testTVDetail);
      verify(mockGetTVShowWatchlistStatus.execute(testTVDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      when(mockSaveTVShowWatchlist.execute(testTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetTVShowWatchlistStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      await provider.addWatchlist(testTVDetail);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when remove watchlist failed', () async {
      when(mockRemoveTVShowWatchlist.execute(testTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetTVShowWatchlistStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      await provider.removeFromWatchlist(testTVDetail);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVShows));
      await provider.fetchTVShowDetail(tId);
      expect(provider.tvShowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

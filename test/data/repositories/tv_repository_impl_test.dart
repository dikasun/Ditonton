import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVModel(
    adult: false,
    backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
    genreIds: [18, 80],
    id: 1396,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Breaking Bad",
    overview:
        "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
    popularity: 288.187,
    posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
    name: "Breaking Bad",
    voteAverage: 8.9,
    voteCount: 11696,
  );

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

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('Now Playing TV Shows', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTVShows())
          .thenAnswer((_) async => tTVModelList);
      final result = await repository.getNowPlayingTVShows();
      verify(mockRemoteDataSource.getNowPlayingTVShows());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTVShows())
          .thenThrow(ServerException());
      final result = await repository.getNowPlayingTVShows();
      verify(mockRemoteDataSource.getNowPlayingTVShows());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getNowPlayingTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getNowPlayingTVShows();
      verify(mockRemoteDataSource.getNowPlayingTVShows());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TV Shows', () {
    test('should return tv show list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularTVShows())
          .thenAnswer((_) async => tTVModelList);
      final result = await repository.getPopularTVShows();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularTVShows())
          .thenThrow(ServerException());
      final result = await repository.getPopularTVShows();
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getPopularTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularTVShows();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated TV Shows', () {
    test('should return tv show list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenAnswer((_) async => tTVModelList);
      final result = await repository.getTopRatedTVShows();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedTVShows();
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedTVShows();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get TV Show Detail', () {
    final tId = 1;
    final tTVResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      createdBy: [
        CreatedByModel(
          id: 1,
          creditId: "creditId",
          name: "name",
          gender: 1,
        ),
      ],
      episodeRunTime: [1, 2, 3],
      firstAirDate: "firstAirDate",
      genres: [
        GenreModel(
          id: 1,
          name: "name",
        ),
      ],
      homepage: "https://google.com",
      id: 1,
      inProduction: false,
      languages: ["languages"],
      lastAirDate: "lastAirDate",
      lastEpisodeToAir: TEpisodeToAirModel(
        id: 1,
        name: "name",
        overview: "overview",
        voteAverage: 1,
        voteCount: 1,
        airDate: "airDate",
        episodeNumber: 1,
        productionCode: "productionCode",
        seasonNumber: 1,
        showId: 1,
      ),
      name: "title",
      nextEpisodeToAir: TEpisodeToAirModel(
        id: 1,
        name: "name",
        overview: "overview",
        voteAverage: 1,
        voteCount: 1,
        airDate: "airDate",
        episodeNumber: 1,
        productionCode: "productionCode",
        seasonNumber: 1,
        showId: 1,
      ),
      networks: [
        NetworkModel(
          id: 1,
          logoPath: "logoPath",
          name: "name",
          originCountry: "originCountry",
        ),
      ],
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ["originCountry"],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      productionCompanies: [
        NetworkModel(
          id: 1,
          logoPath: "logoPath",
          name: "name",
          originCountry: "originCountry",
        ),
      ],
      productionCountries: [
        ProductionCountryModel(
          iso31661: "iso31661",
          name: "name",
        ),
      ],
      seasons: [
        SeasonModel(
          airDate: "airDate",
          episodeCount: 1,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1,
        ),
      ],
      spokenLanguages: [
        SpokenLanguageModel(
          englishName: "englishName",
          iso6391: "iso6391",
          name: "name",
        ),
      ],
      status: "status",
      tagline: "tagline",
      type: "type",
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenAnswer((_) async => tTVResponse);
      final result = await repository.getTVShowDetail(tId);
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(Right(testTVDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getTVShowDetail(tId);
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTVShowDetail(tId);
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful',
        () async {
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenAnswer((_) async => tTVList);
      final result = await repository.getTVShowRecommendations(tId);
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getTVShowRecommendations(tId);
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTVShowRecommendations(tId);
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search TV Shows', () {
    final tQuery = 'breaking bad';

    test('should return tv list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenAnswer((_) async => tTVModelList);
      final result = await repository.searchTVShows(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchTVShows(tQuery);
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchTVShows(tQuery);
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {

      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTVDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTVDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlist(testTVDetail);
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTVDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTVShowById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of TV Shows', () async {
      when(mockLocalDataSource.getWatchlistTVShows())
          .thenAnswer((_) async => [testTVTable]);
      final result = await repository.getWatchlistTVShows();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}

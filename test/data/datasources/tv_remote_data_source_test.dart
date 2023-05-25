import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Shows', () {
    final tTVShowList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/now_playing.json')))
        .tvList;

    test('should return list of TV Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/now_playing.json'), 200));
      final result = await dataSource.getNowPlayingTVShows();
      expect(result, equals(tTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getNowPlayingTVShows();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Shows', () {
    final tTVShowList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv/popular.json')))
            .tvList;

    test('should return list of tv shows when response is success (200)',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/popular.json'), 200));
      final result = await dataSource.getPopularTVShows();
      expect(result, tTVShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getPopularTVShows();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Shows', () {
    final tTVShowList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv/top_rated.json')))
            .tvList;

    test('should return list of tv shows when response code is 200 ', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/top_rated.json'), 200));
      final result = await dataSource.getTopRatedTVShows();
      expect(result, tTVShowList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTopRatedTVShows();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show detail', () {
    final tId = 1;
    final tTVShowDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv/tv_detail.json')));

    test('should return tv show detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/tv_detail.json'), 200));
      final result = await dataSource.getTVShowDetail(tId);
      expect(result, equals(tTVShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTVShowDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show recommendations', () {
    final tTVShowList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/tv_recommendations.json')))
        .tvList;
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/tv_recommendations.json'), 200));
      final result = await dataSource.getTVShowRecommendations(tId);
      expect(result, equals(tTVShowList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTVShowRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv shows', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/search_breaking_bad_tv_show.json')))
        .tvList;
    final tQuery = 'Spiderman';

    test('should return list of tv shows when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/search_breaking_bad_tv_show.json'), 200));
      final result = await dataSource.searchTVShows(tQuery);
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchTVShows(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

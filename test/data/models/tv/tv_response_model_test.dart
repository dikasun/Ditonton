import 'dart:convert';

import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTVModel = TVModel(
    adult: null,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: '/path.jpg',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTVResponseModel = TVResponse(tvList: <TVModel>[tTVModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/now_playing.json'));
      final result = TVResponse.fromJson(jsonMap);
      expect(result, tTVResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTVResponseModel.toJson();
      final expectedJsonMap = {
        "results": [
          {
            "adult": null,
            "backdrop_path": '/path.jpg',
            "genre_ids": [1, 2, 3],
            "id": 1,
            "origin_country": ['originCountry'],
            "original_language": 'originalLanguage',
            "original_title": 'originalName',
            "overview": 'overview',
            "popularity": 1,
            "poster_path": '/path.jpg',
            "title": 'name',
            "vote_average": 1,
            "vote_count": 1,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}

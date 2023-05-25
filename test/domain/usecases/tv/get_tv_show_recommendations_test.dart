import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowRecommendations(mockTVRepository);
  });

  final tId = 1;
  final tTVShows = <TV>[];

  test('should get list of tv show recommendations from the repository',
          () async {
        when(mockTVRepository.getTVShowRecommendations(tId))
            .thenAnswer((_) async => Right(tTVShows));
        final result = await usecase.execute(tId);
        expect(result, Right(tTVShows));
      });
}

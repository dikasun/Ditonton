import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_show_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTVShowWatchlist usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveTVShowWatchlist(mockTVRepository);
  });

  test('should save tv show to the repository', () async {
    when(mockTVRepository.saveWatchlist(testTVDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    final result = await usecase.execute(testTVDetail);
    verify(mockTVRepository.saveWatchlist(testTVDetail));
    expect(result, Right('Added to Watchlist'));
  });
}

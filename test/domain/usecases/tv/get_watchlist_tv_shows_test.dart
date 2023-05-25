import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistTVShows(mockTVRepository);
  });

  test('should get list of tv shows from the repository', () async {
    when(mockTVRepository.getWatchlistTVShows())
        .thenAnswer((_) async => Right(testTVList));
    final result = await usecase.execute();
    expect(result, Right(testTVList));
  });
}

import 'package:ditonton/domain/usecases/tv/get_tv_show_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowWatchListStatus usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowWatchListStatus(mockTVRepository);
  });

  test('should get watchlist status from repository', () async {
    when(mockTVRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    final result = await usecase.execute(1);
    expect(result, true);
  });
}

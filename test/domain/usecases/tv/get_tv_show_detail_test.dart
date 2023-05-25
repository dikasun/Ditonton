import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowDetail(mockTVRepository);
  });

  final tId = 1;

  test('should get tv show detail from the repository', () async {
    when(mockTVRepository.getTVShowDetail(tId))
        .thenAnswer((_) async => Right(testTVDetail));
    final result = await usecase.execute(tId);
    expect(result, Right(testTVDetail));
  });
}

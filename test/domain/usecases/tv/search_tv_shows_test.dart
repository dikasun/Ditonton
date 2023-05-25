import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTVShows(mockTVRepository);
  });

  final tTVShows = <TV>[];
  final tQuery = 'Breaking Bad';

  test('should get list of tv shows from the repository', () async {
    when(mockTVRepository.searchTVShows(tQuery))
        .thenAnswer((_) async => Right(tTVShows));
    final result = await usecase.execute(tQuery);
    expect(result, Right(tTVShows));
  });
}

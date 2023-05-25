import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTopRatedTVShows(mockTVRepository);
  });

  final tTVShows = <TV>[];

  test('should get list of tv shows from repository', () async {
    when(mockTVRepository.getTopRatedTVShows())
        .thenAnswer((_) async => Right(tTVShows));
    final result = await usecase.execute();
    expect(result, Right(tTVShows));
  });
}

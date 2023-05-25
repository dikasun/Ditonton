import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetPopularTVShows(mockTVRepository);
  });

  final tTVShows = <TV>[];

  test(
      'should get list of tv shows from the repository when execute function is called',
      () async {
    when(mockTVRepository.getPopularTVShows())
        .thenAnswer((_) async => Right(tTVShows));
    final result = await usecase.execute();
    expect(result, Right(tTVShows));
  });
}

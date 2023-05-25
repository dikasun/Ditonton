import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetNowPlayingTVShows(mockTVRepository);
  });

  final tTVShows = <TV>[];

  test('should get list of tv shows from the repository', () async {
    when(mockTVRepository.getNowPlayingTVShows())
        .thenAnswer((_) async => Right(tTVShows));
    final result = await usecase.execute();
    expect(result, Right(tTVShows));
  });
}

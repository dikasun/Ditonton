import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_show.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_show_notifier_test.mocks.dart';

@GenerateMocks([
  GetPopularTVShows,
])
void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTVShowsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTVShows = MockGetPopularTVShows();
    notifier = PopularTVShowsNotifier(
      getPopularTVShows: mockGetPopularTVShows,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  final tTVShow = TV(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: [
      "originCountry",
    ],
    originalLanguage: "originalLanguage",
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVShowList = <TV>[tTVShow];

  test('should change state to loading when usecase is called', () async {
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Right(tTVShowList));
    notifier.fetchPopularTVShows();
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv shows data when data is gotten successfully',
      () async {
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Right(tTVShowList));
    await notifier.fetchPopularTVShows();
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvShows, tTVShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    await notifier.fetchPopularTVShows();
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}

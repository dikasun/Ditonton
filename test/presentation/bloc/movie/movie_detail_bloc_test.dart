import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/event/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/state/movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  final tMovieDetailModel = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieEmptyState());
  });

  blocTest<MovieDetailBloc, MovieState>(
    'Should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tMovieDetailModel.id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(MovieDetailEvent(movieId: tMovieDetailModel.id)),
    expect: () => [
      MovieLoadingState(),
      MovieErrorState(message: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieDetailModel.id));
    },
  );

  blocTest<MovieDetailBloc, MovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tMovieDetailModel.id))
          .thenAnswer((_) async => Right(tMovieDetailModel));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(MovieDetailEvent(movieId: tMovieDetailModel.id)),
    expect: () => [
      MovieLoadingState(),
      MovieHasDataState(result: tMovieDetailModel),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieDetailModel.id));
    },
  );
}

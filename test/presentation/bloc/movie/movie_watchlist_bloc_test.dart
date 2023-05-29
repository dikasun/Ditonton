import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_movie_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/event/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/state/movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
      mockGetWatchlistMovies,
      mockGetMovieWatchListStatus,
      mockSaveMovieWatchlist,
      mockRemoveMovieWatchlist,
    );
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = [tMovie];

  final tMovieDetail = MovieDetail(
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
    expect(movieWatchlistBloc.state, MovieEmptyState());
  });

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieGetWatchlistEvent()),
    expect: () => [
      MovieLoadingState(),
      MovieErrorState(message: 'Database Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([]));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieGetWatchlistEvent()),
    expect: () => [
      MovieLoadingState(),
      MovieEmptyState(),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieGetWatchlistEvent()),
    expect: () => [
      MovieLoadingState(),
      MovieHasDataState(result: tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Watchlist Status] when get watchlist status successfully',
    build: () {
      when(mockGetMovieWatchListStatus.execute(1))
          .thenAnswer((_) async => true);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieGetWatchlistStatusEvent(movieId: 1)),
    expect: () => [
      MovieWatchlistStatusState(status: true),
    ],
    verify: (bloc) {
      verify(mockGetMovieWatchListStatus.execute(1));
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Error] when save watchlist is unsuccessful',
    build: () {
      when(mockSaveMovieWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieAddWatchlistEvent(movie: tMovieDetail)),
    expect: () => [
      MovieErrorState(message: 'Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveMovieWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Success] when data is saved to watchlist',
    build: () {
      when(mockSaveMovieWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieAddWatchlistEvent(movie: tMovieDetail)),
    expect: () => [
      MovieSuccessState(result: 'Added to Watchlist'),
    ],
    verify: (bloc) {
      verify(mockSaveMovieWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Error] when remove watchlist is unsuccessful',
    build: () {
      when(mockRemoveMovieWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieRemoveWatchlistEvent(movie: tMovieDetail)),
    expect: () => [
      MovieErrorState(message: 'Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveMovieWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieState>(
    'Should emit [Success] when data is removed from watchlist',
    build: () {
      when(mockRemoveMovieWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(MovieRemoveWatchlistEvent(movie: tMovieDetail)),
    expect: () => [
      MovieSuccessState(result: 'Removed from Watchlist'),
    ],
    verify: (bloc) {
      verify(mockRemoveMovieWatchlist.execute(tMovieDetail));
    },
  );
}

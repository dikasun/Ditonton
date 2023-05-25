import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv/now_playing_tv_shows_notifier.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_shows_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_shows_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_show_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/tv_local_data_source.dart';
import 'data/datasources/tv_remote_data_source.dart';
import 'data/repositories/tv_repository_impl.dart';
import 'domain/repositories/tv_repository.dart';
import 'domain/usecases/movie/remove_movie_watchlist.dart';
import 'domain/usecases/movie/save_movie_watchlist.dart';
import 'domain/usecases/tv/get_now_playing_tv_show.dart';
import 'domain/usecases/tv/get_popular_tv_show.dart';
import 'domain/usecases/tv/get_top_rated_tv_show.dart';
import 'domain/usecases/tv/get_tv_show_detail.dart';
import 'domain/usecases/tv/get_tv_show_recommendations.dart';
import 'domain/usecases/tv/get_tv_show_watchlist_status.dart';
import 'domain/usecases/tv/get_watchlist_tv_show.dart';
import 'domain/usecases/tv/remove_tv_show_watchlist.dart';
import 'domain/usecases/tv/save_tv_show_watchlist.dart';
import 'domain/usecases/tv/search_tv_show.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      getPopularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => TVShowListNotifier(
      getNowPlayingTVShows: locator(),
      getPopularTVShows: locator(),
      getTopRatedTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TVShowDetailNotifier(
      getTVShowDetail: locator(),
      getTVShowRecommendations: locator(),
      getTVShowWatchListStatus: locator(),
      saveTVShowWatchlist: locator(),
      removeTVShowWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TVShowSearchNotifier(
      searchTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTVShowsNotifier(
      getNowPlayingTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTVShowsNotifier(
      getPopularTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTVShowsNotifier(
      getTopRatedTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTVShowNotifier(
      getWatchlistTVShows: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTVShows(locator()));
  locator.registerLazySingleton(() => GetPopularTVShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVShows(locator()));
  locator.registerLazySingleton(() => GetTVShowDetail(locator()));
  locator.registerLazySingleton(() => GetTVShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVShows(locator()));
  locator.registerLazySingleton(() => GetTVShowWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTVShowWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTVShowWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVShows(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVLocalDataSource>(
      () => TVLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}

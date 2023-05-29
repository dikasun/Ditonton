import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/data/http_ssl_pinning.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv/now_playing_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_shows_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieNowPlayingBloc>()),
        BlocProvider(create: (_) => di.locator<MoviePopularBloc>()),
        BlocProvider(create: (_) => di.locator<MovieTopRatedBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowNowPlayingBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowPopularBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowTopRatedBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<TVShowWatchlistBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTVShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTVShowPage());
            case NowPlayingTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTVShowsPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTVShowsPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTVShowsPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TVShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVShowDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviesPage());
            case SearchTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTVShowsPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTVShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTVShowsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

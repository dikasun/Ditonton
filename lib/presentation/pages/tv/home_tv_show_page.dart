import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'now_playing_tv_shows_page.dart';
import 'tv_show_detail_page.dart';

class HomeTVShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv-show';

  @override
  _HomeTVShowPageState createState() => _HomeTVShowPageState();
}

class _HomeTVShowPageState extends State<HomeTVShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<TVShowListNotifier>(context, listen: false)
          ..fetchNowPlayingTVShows()
          ..fetchPopularTVShows()
          ..fetchTopRatedTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv_rounded),
              title: Text('TV Shows'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movies Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('TV Shows Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVShowsPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVShowsPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingTVShowsPage.ROUTE_NAME),
              ),
              Consumer<TVShowListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return Center(
                    key: ValueKey("NowPlayingCenter"),
                    child: CircularProgressIndicator(
                      key: ValueKey("NowPlayingCircularProgressIndicator"),
                    ),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVShowList(data.nowPlayingTVShows);
                } else {
                  return Text(
                    'Failed',
                    key: ValueKey("error_message"),
                  );
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVShowsPage.ROUTE_NAME),
              ),
              Consumer<TVShowListNotifier>(builder: (context, data, child) {
                final state = data.popularTVShowsState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVShowList(data.popularTVShows);
                } else {
                  return Text(
                    'Failed',
                    key: ValueKey("error_message"),
                  );
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTVShowsPage.ROUTE_NAME),
              ),
              Consumer<TVShowListNotifier>(builder: (context, data, child) {
                final state = data.topRatedTVShowsState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVShowList(data.topRatedTVShows);
                } else {
                  return Text(
                    'Failed',
                    key: ValueKey("error_message"),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVShowList extends StatelessWidget {
  final List<TV> tvShows;

  TVShowList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../bloc/tv/event/tv_show_event.dart';
import '../../bloc/tv/state/tv_show_state.dart';
import '../../bloc/tv/tv_show_detail_bloc.dart';
import '../../bloc/tv/tv_show_recommendation_bloc.dart';
import '../../bloc/tv/tv_show_watchlist_bloc.dart';

class TVShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-show';

  final int id;

  TVShowDetailPage({required this.id});

  @override
  TVShowDetailPageState createState() => TVShowDetailPageState();
}

class TVShowDetailPageState extends State<TVShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TVShowDetailBloc>(context)
          .add(TVShowDetailEvent(tvShowId: widget.id));
      BlocProvider.of<TVShowRecommendationBloc>(context)
          .add(TVShowRecommendationEvent(tvShowId: widget.id));
      BlocProvider.of<TVShowWatchlistBloc>(context)
          .add(TVShowGetWatchlistStatusEvent(tvShowId: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVShowDetailBloc, TVShowState>(
        builder: (context, state) {
          if (state is TVShowLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TVShowHasDataState) {
            return SafeArea(
              child: DetailContent(state.result),
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVDetail tvShow;

  DetailContent(this.tvShow);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvShow.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<TVShowWatchlistBloc, TVShowState>(
                              listener: (context, state) {
                                if (state is TVShowSuccessState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.result)));
                                } else if (state is TVShowErrorState) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(state.message),
                                        );
                                      });
                                }
                                BlocProvider.of<TVShowWatchlistBloc>(context)
                                    .add(TVShowGetWatchlistStatusEvent(
                                        tvShowId: tvShow.id));
                              },
                              builder: (context, state) {
                                if (state is TVShowWatchlistStatusState) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (!state.status) {
                                        BlocProvider.of<TVShowWatchlistBloc>(
                                                context)
                                            .add(TVShowAddWatchlistEvent(
                                                tvShow: tvShow));
                                      } else {
                                        BlocProvider.of<TVShowWatchlistBloc>(
                                                context)
                                            .add(TVShowRemoveWatchlistEvent(
                                                tvShow: tvShow));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.status
                                            ? Icon(Icons.check)
                                            : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Text('Failed');
                                }
                              },
                            ),
                            Text(
                              _showGenres(tvShow.genres),
                            ),
                            Text(
                              "Season : ${tvShow.numberOfSeasons}",
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShow.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TVShowRecommendationBloc, TVShowState>(
                              builder: (context, state) {
                                if (state is TVShowLoadingState) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TVShowErrorState) {
                                  return Text(state.message);
                                } else if (state is TVShowHasDataState) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVShowDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tv/state/tv_show_state.dart';

class WatchlistTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-show';

  @override
  _WatchlistTVShowsPageState createState() => _WatchlistTVShowsPageState();
}

class _WatchlistTVShowsPageState extends State<WatchlistTVShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<TVShowWatchlistBloc>(context)
        .add(TVShowGetWatchlistEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    BlocProvider.of<TVShowWatchlistBloc>(context)
        .add(TVShowGetWatchlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVShowWatchlistBloc, TVShowState>(
          builder: (context, state) {
            if (state is TVShowLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TVShowHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.result[index];
                  return TVShowCard(tvShow);
                },
                itemCount: state.result.length,
              );
            } else if (state is TVShowErrorState) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

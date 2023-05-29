import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_now_playing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tv/state/tv_show_state.dart';
import '../../widgets/tv_show_card_list.dart';

class NowPlayingTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv-show';

  @override
  State<NowPlayingTVShowsPage> createState() => _NowPlayingTVShowsPageState();
}

class _NowPlayingTVShowsPageState extends State<NowPlayingTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<TVShowNowPlayingBloc>(context)
        .add(TVShowNowPlayingEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVShowNowPlayingBloc, TVShowState>(
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
}

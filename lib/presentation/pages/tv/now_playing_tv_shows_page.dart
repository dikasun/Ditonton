import 'package:ditonton/presentation/provider/tv/now_playing_tv_shows_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
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
    Future.microtask(() =>
        Provider.of<NowPlayingTVShowsNotifier>(context, listen: false)
            .fetchNowPlayingTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingTVShowsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data.tvShows[index];
                  return TVShowCard(tvShow);
                },
                itemCount: data.tvShows.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

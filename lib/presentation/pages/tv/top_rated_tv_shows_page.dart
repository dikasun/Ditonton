import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_top_rated_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tv/state/tv_show_state.dart';

class TopRatedTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-show';

  @override
  _TopRatedTVShowsPageState createState() => _TopRatedTVShowsPageState();
}

class _TopRatedTVShowsPageState extends State<TopRatedTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<TVShowTopRatedBloc>(context)
        .add(TVShowTopRatedEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVShowTopRatedBloc, TVShowState>(
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

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_show.dart';
import 'package:flutter/foundation.dart';

class NowPlayingTVShowsNotifier extends ChangeNotifier {
  final GetNowPlayingTVShows getNowPlayingTVShows;

  NowPlayingTVShowsNotifier({required this.getNowPlayingTVShows});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TV> _tvShows = [];

  List<TV> get tvShows => _tvShows;

  String _message = '';

  String get message => _message;

  Future<void> fetchNowPlayingTVShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowsData) {
        _tvShows = tvShowsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}

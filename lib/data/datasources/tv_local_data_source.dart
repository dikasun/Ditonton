import 'package:ditonton/data/models/watchlist/watchlist_table.dart';

import '../../common/exception.dart';
import 'db/database_helper.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlist(WatchlistTable tvShow);

  Future<String> removeWatchlist(WatchlistTable tvShow);

  Future<WatchlistTable?> getTVShowById(int id);

  Future<List<WatchlistTable>> getWatchlistTVShows();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable tvShow) async {
    try {
      await databaseHelper.insertWatchlist(tvShow);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(WatchlistTable tvShow) async {
    try {
      await databaseHelper.removeWatchlist(tvShow);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getTVShowById(int id) async {
    final result = await databaseHelper.getItemById(id, 0);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistTVShows() async {
    final result = await databaseHelper.getWatchlistTvShows();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}

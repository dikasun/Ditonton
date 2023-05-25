import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv/tv.dart';
import '../entities/tv/tv_detail.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getNowPlayingTVShows();

  Future<Either<Failure, List<TV>>> getPopularTVShows();

  Future<Either<Failure, List<TV>>> getTopRatedTVShows();

  Future<Either<Failure, TVDetail>> getTVShowDetail(int id);

  Future<Either<Failure, List<TV>>> getTVShowRecommendations(int id);

  Future<Either<Failure, List<TV>>> searchTVShows(String query);

  Future<Either<Failure, String>> saveWatchlist(TVDetail tvShow);

  Future<Either<Failure, String>> removeWatchlist(TVDetail tvShow);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<TV>>> getWatchlistTVShows();
}

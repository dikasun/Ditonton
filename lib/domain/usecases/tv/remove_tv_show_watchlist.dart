import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class RemoveTVShowWatchlist {
  final TVRepository repository;

  RemoveTVShowWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tvShow) {
    return repository.removeWatchlist(tvShow);
  }
}

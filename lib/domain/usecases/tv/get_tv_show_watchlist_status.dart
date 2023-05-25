import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTVShowWatchListStatus {
  final TVRepository repository;

  GetTVShowWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}

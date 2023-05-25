import 'package:ditonton/data/models/watchlist/watchlist_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 1,
);

final testMovieTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 1,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'isMovie': 1,
};

final testTV = TV(
  adult: false,
  backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
  genreIds: [18, 80],
  id: 1396,
  originCountry: ["US"],
  originalLanguage: "en",
  originalTitle: "Breaking Bad",
  overview:
      "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
  popularity: 288.187,
  posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
  title: "Breaking Bad",
  voteAverage: 8.9,
  voteCount: 11696,
);

final testTVList = [testTV];

// final testTVDetail = TVDetail(
//   adult: false,
//   backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
//   createdBy: [
//     CreatedBy(
//       id: 66633,
//       creditId: "52542286760ee31328001a7b",
//       name: "Vince Gilligan",
//       gender: 2,
//       profilePath: "/z3E0DhBg1V1PZVEtS9vfFPzOWYB.jpg",
//     )
//   ],
//   episodeRunTime: [],
//   firstAirDate: "2008-01-20",
//   genres: [
//     Genre(id: 18, name: "Drama"),
//     Genre(id: 80, name: "Crime"),
//   ],
//   homepage: "http://www.amc.com/shows/breaking-bad",
//   id: 1396,
//   inProduction: false,
//   languages: [
//     "en",
//     "de",
//     "es",
//   ],
//   lastAirDate: "2013-09-29",
//   lastEpisodeToAir: TEpisodeToAir(
//       id: 62161,
//       name: "Felina",
//       overview: "All bad things must come to an end.",
//       voteAverage: 9.2,
//       voteCount: 174,
//       airDate: "2013-09-29",
//       episodeNumber: 16,
//       productionCode: "",
//       seasonNumber: 5,
//       showId: 1396),
//   name: "Breaking Bad",
//   nextEpisodeToAir: null,
//   networks: [
//     Network(
//       id: 174,
//       logoPath: "/alqLicR1ZMHMaZGP3xRQxn9sq7p.png",
//       name: "AMC",
//       originCountry: "US",
//     ),
//   ],
//   numberOfEpisodes: 62,
//   numberOfSeasons: 5,
//   originCountry: [
//     "US",
//   ],
//   originalLanguage: "en",
//   originalName: "Breaking Bad",
//   overview:
//       "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
//   popularity: 288.187,
//   posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
//   productionCompanies: [
//     Network(
//       id: 11073,
//       logoPath: "/aCbASRcI1MI7DXjPbSW9Fcv9uGR.png",
//       name: "Sony Pictures Television Studios",
//       originCountry: "US",
//     ),
//     Network(
//       id: 33742,
//       logoPath: null,
//       name: "High Bridge Productions",
//       originCountry: "US",
//     ),
//     Network(
//       id: 2605,
//       logoPath: null,
//       name: "Gran Via Productions",
//       originCountry: "US",
//     ),
//   ],
//   productionCountries: [
//     ProductionCountry(
//       iso31661: "US",
//       name: "United States of America",
//     ),
//   ],
//   seasons: [
//     Season(
//       airDate: "2009-02-17",
//       episodeCount: 11,
//       id: 3577,
//       name: "Specials",
//       overview: "",
//       posterPath: "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
//       seasonNumber: 0,
//     ),
//     Season(
//       airDate: "2008-01-20",
//       episodeCount: 7,
//       id: 3572,
//       name: "Season 1",
//       overview:
//           "High school chemistry teacher Walter White's life is suddenly transformed by a dire medical diagnosis. Street-savvy former student Jesse Pinkman \"teaches\" Walter a new trade.",
//       posterPath: "/1BP4xYv9ZG4ZVHkL7ocOziBbSYH.jpg",
//       seasonNumber: 1,
//     ),
//     Season(
//       airDate: "2009-03-08",
//       episodeCount: 13,
//       id: 3573,
//       name: "Season 2",
//       overview:
//           "Walt must deal with the chain reaction of his choice, as he and Jesse face new and severe consequences. When danger and suspicion around Walt escalate, he is pushed to new levels of desperation. Just how much higher will the stakes rise? How far is Walt willing to go to ensure his family's security? Will his grand plan spiral out of control?",
//       posterPath: "/e3oGYpoTUhOFK0BJfloru5ZmGV.jpg",
//       seasonNumber: 2,
//     ),
//     Season(
//       airDate: "2010-03-21",
//       episodeCount: 13,
//       id: 3575,
//       name: "Season 3",
//       overview:
//           "Walt continues to battle dueling identities: a desperate husband and father trying to provide for his family, and a newly appointed key player in the Albuquerque drug trade. As the danger around him escalates, Walt is now entrenched in the complex worlds of an angst-ridden family on the verge of dissolution, and the ruthless and unrelenting drug cartel.",
//       posterPath: "/ffP8Q8ew048YofHRnFVM18B2fPG.jpg",
//       seasonNumber: 3,
//     ),
//     Season(
//       airDate: "2011-07-17",
//       episodeCount: 13,
//       id: 3576,
//       name: "Season 4",
//       overview:
//           "Walt and Jesse must cope with the fallout of their previous actions, both personally and professionally. Tension mounts as Walt faces a true standoff with his employer, Gus, with neither side willing or able to back down. Walt must also adjust to a new relationship with Skyler, whom while still reconciling her relationship with Walt, is committed to properly laundering Walt’s money and ensuring her sister Marie and an ailing Hank are financially stable.",
//       posterPath: "/5ewrnKp4TboU4hTLT5cWO350mHj.jpg",
//       seasonNumber: 4,
//     ),
//     Season(
//       airDate: "2012-07-15",
//       episodeCount: 16,
//       id: 3578,
//       name: "Season 5",
//       overview:
//           "Walt is faced with the prospect of moving on in a world without his enemy. As the pressure of a criminal life starts to build, Skyler struggles to keep Walt’s terrible secrets. Facing resistance from sometime adversary and former Fring lieutenant Mike, Walt tries to keep his world from falling apart even as his DEA Agent brother in law, Hank, finds numerous leads that could blaze a path straight to Walt. \n\nAll bad things must come to an end.",
//       posterPath: "/r3z70vunihrAkjILQKWHX0G2xzO.jpg",
//       seasonNumber: 5,
//     ),
//   ],
//   spokenLanguages: [
//     SpokenLanguage(
//       englishName: "English",
//       iso6391: "en",
//       name: "English",
//     ),
//     SpokenLanguage(
//       englishName: "German",
//       iso6391: "de",
//       name: "Deutsch",
//     ),
//     SpokenLanguage(
//       englishName: "Spanish",
//       iso6391: "es",
//       name: "Español",
//     ),
//   ],
//   status: "Ended",
//   tagline: "",
//   type: "Scripted",
//   voteAverage: 8.88,
//   voteCount: 11696,
// );

final testTVDetail = TVDetail(
  adult: false,
  backdropPath: 'backdropPath',
  createdBy: [
    CreatedBy(
      id: 1,
      creditId: "creditId",
      name: "name",
      gender: 1,
    ),
  ],
  episodeRunTime: [1, 2, 3],
  firstAirDate: "firstAirDate",
  genres: [
    Genre(
      id: 1,
      name: "name",
    ),
  ],
  homepage: "https://google.com",
  id: 1,
  inProduction: false,
  languages: ["languages"],
  lastAirDate: "lastAirDate",
  lastEpisodeToAir: TEpisodeToAir(
    id: 1,
    name: "name",
    overview: "overview",
    voteAverage: 1,
    voteCount: 1,
    airDate: "airDate",
    episodeNumber: 1,
    productionCode: "productionCode",
    seasonNumber: 1,
    showId: 1,
  ),
  name: "title",
  nextEpisodeToAir: TEpisodeToAir(
    id: 1,
    name: "name",
    overview: "overview",
    voteAverage: 1,
    voteCount: 1,
    airDate: "airDate",
    episodeNumber: 1,
    productionCode: "productionCode",
    seasonNumber: 1,
    showId: 1,
  ),
  networks: [
    Network(
      id: 1,
      logoPath: "logoPath",
      name: "name",
      originCountry: "originCountry",
    ),
  ],
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originCountry: ["originCountry"],
  originalLanguage: "originalLanguage",
  originalName: "originalName",
  overview: "overview",
  popularity: 1,
  posterPath: "posterPath",
  productionCompanies: [
    Network(
      id: 1,
      logoPath: "logoPath",
      name: "name",
      originCountry: "originCountry",
    ),
  ],
  productionCountries: [
    ProductionCountry(
      iso31661: "iso31661",
      name: "name",
    ),
  ],
  seasons: [
    Season(
      airDate: "airDate",
      episodeCount: 1,
      id: 1,
      name: "name",
      overview: "overview",
      posterPath: "posterPath",
      seasonNumber: 1,
    ),
  ],
  spokenLanguages: [
    SpokenLanguage(
      englishName: "englishName",
      iso6391: "iso6391",
      name: "name",
    ),
  ],
  status: "status",
  tagline: "tagline",
  type: "type",
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 0,
);

final testTVTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 0,
);

final testTVMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'isMovie': 0,
};

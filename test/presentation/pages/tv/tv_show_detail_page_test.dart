import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/state/tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/tv/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockTVShowDetailBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowDetailBloc {}

class MockTVShowRecommendationBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowRecommendationBloc {}

class MockTVShowWatchlistBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowWatchlistBloc {}

class TVShowEventFake extends Fake implements TVShowEvent {}

class TVShowStateFake extends Fake implements TVShowState {}

void main() {
  late MockTVShowDetailBloc mockTVShowDetailBloc;
  late MockTVShowRecommendationBloc mockTVShowRecommendationBloc;
  late MockTVShowWatchlistBloc mockTVShowWatchlistBloc;

  setUp(() {
    mockTVShowDetailBloc = MockTVShowDetailBloc();
    mockTVShowRecommendationBloc = MockTVShowRecommendationBloc();
    mockTVShowWatchlistBloc = MockTVShowWatchlistBloc();
  });

  setUpAll(() {
    registerFallbackValue(TVShowEventFake);
    registerFallbackValue(TVShowStateFake);
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVShowDetailBloc>(
          create: (context) => mockTVShowDetailBloc,
        ),
        BlocProvider<TVShowRecommendationBloc>(
          create: (context) => mockTVShowRecommendationBloc,
        ),
        BlocProvider<TVShowWatchlistBloc>(
          create: (context) => mockTVShowWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVShowDetailBloc.state)
        .thenReturn(TVShowHasDataState(result: testTVDetail));
    when(() => mockTVShowRecommendationBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[]));
    when(() => mockTVShowWatchlistBloc.state)
        .thenReturn(TVShowWatchlistStatusState(status: false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTVShowDetailBloc.state)
        .thenReturn(TVShowHasDataState(result: testTVDetail));
    when(() => mockTVShowRecommendationBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[]));
    when(() => mockTVShowWatchlistBloc.state)
        .thenReturn(TVShowWatchlistStatusState(status: true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}

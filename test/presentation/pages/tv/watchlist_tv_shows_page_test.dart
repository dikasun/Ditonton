import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/state/tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockTVShowWatchlistBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowWatchlistBloc {}

class TVShowEventFake extends Fake implements TVShowEvent {}

class TVShowStateFake extends Fake implements TVShowState {}

void main() {
  late MockTVShowWatchlistBloc mockTVShowWatchlistBloc;

  setUp(() {
    mockTVShowWatchlistBloc = MockTVShowWatchlistBloc();
  });

  setUpAll(() {
    registerFallbackValue(TVShowEventFake);
    registerFallbackValue(TVShowStateFake);
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVShowWatchlistBloc>(
      create: (context) => mockTVShowWatchlistBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTVShowWatchlistBloc.state).thenReturn(TVShowLoadingState());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTVShowWatchlistBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[testTV]));

    final listViewFinder = find.byType(ListView);
    final tvShowCardFinder = find.byType(TVShowCard);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvShowCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTVShowWatchlistBloc.state)
        .thenReturn(TVShowErrorState(message: 'Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

    expect(textFinder, findsOneWidget);
  });
}

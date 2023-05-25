import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_search_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_shows_page_test.mocks.dart';

@GenerateMocks([TVShowSearchNotifier])
void main() {
  late MockTVShowSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVShowSearchNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVShowSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(SearchTVShowsPage()));

    expect(centerFinder, findsWidgets);
    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn(<TV>[testTV]);

    final listViewFinder = find.byType(ListView);
    final tvShowCardFinder = find.byType(TVShowCard);

    await tester.pumpWidget(_makeTestableWidget(SearchTVShowsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvShowCardFinder, findsWidgets);
  });

  testWidgets('Page should display container when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(SearchTVShowsPage()));

    expect(containerFinder, findsOneWidget);
  });
}

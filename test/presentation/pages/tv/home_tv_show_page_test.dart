import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_show_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_show_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_tv_show_page_test.mocks.dart';

@GenerateMocks([TVShowListNotifier])
void main() {
  late MockTVShowListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVShowListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVShowListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page item should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(centerFinder, findsWidgets);
    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page item should display when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingTVShows).thenReturn(<TV>[testTV]);
    when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTVShows).thenReturn(<TV>[testTV]);
    when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTVShows).thenReturn(<TV>[testTV]);

    final listViewFinder = find.byType(ListView);
    final tvShowCardFinder = find.byType(TVShowList);

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(listViewFinder, findsWidgets);
    expect(tvShowCardFinder, findsWidgets);
  });

  testWidgets('Page item should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Error);
    when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Error);
    when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(textFinder, findsWidgets);
  });
  // group('now playing tv shows', () {
  //   testWidgets('Page should display now playing tv show item progress bar when loading',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
  //     when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Empty);
  //     when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Empty);
  //
  //     final progressFinder = find.byKey(ValueKey("NowPlayingCircularProgressIndicator"));
  //     final centerFinder = find.byKey(ValueKey("NowPlayingCenter"));
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(centerFinder, findsWidgets);
  //     expect(progressFinder, findsWidgets);
  //   });
  //
  //   testWidgets('Page should display now playing tv show item when data is loaded',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
  //     when(mockNotifier.nowPlayingTVShows).thenReturn(<TV>[testTV]);
  //     when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Empty);
  //     when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Empty);
  //
  //     final listViewFinder = find.byType(ListView);
  //     final tvShowListFinder = find.byType(TVShowList);
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(listViewFinder, findsOneWidget);
  //     expect(tvShowListFinder, findsOneWidget);
  //   });
  // });

  // group('popular tv shows', () {
  //   testWidgets('Page should display popular tv show item progress bar when loading',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Loading);
  //
  //     final progressFinder = find.byType(CircularProgressIndicator);
  //     final centerFinder = find.byType(Center);
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(centerFinder, findsWidgets);
  //     expect(progressFinder, findsWidgets);
  //   });
  //
  //   testWidgets('Page should display popular tv show item when data is loaded',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.popularTVShowsState).thenReturn(RequestState.Loaded);
  //     when(mockNotifier.popularTVShows).thenReturn(<TV>[testTV]);
  //
  //     final listViewFinder = find.byType(ListView);
  //     final tvShowListFinder = find.byType(TVShowList);
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(listViewFinder, findsOneWidget);
  //     expect(tvShowListFinder, findsWidgets);
  //   });
  // });

  // group('top rated tv shows', () {
  //   testWidgets('Page should display top rated tv show item progress bar when loading',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Loading);
  //
  //     final progressFinder = find.byType(CircularProgressIndicator);
  //     final centerFinder = find.byType(Center);
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(centerFinder, findsWidgets);
  //     expect(progressFinder, findsWidgets);
  //   });
  //
  //   testWidgets('Page should display top rated tv show item when data is loaded',
  //       (WidgetTester tester) async {
  //     when(mockNotifier.topRatedTVShowsState).thenReturn(RequestState.Loaded);
  //     when(mockNotifier.topRatedTVShows).thenReturn(<TV>[testTV]);
  //
  //     final listViewFinder = find.byType(ListView);
  //     final tvShowListFinder = find.byType(TVShowList);
  //
  //     await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));
  //
  //     expect(listViewFinder, findsOneWidget);
  //     expect(tvShowListFinder, findsWidgets);
  //   });
  // });
}

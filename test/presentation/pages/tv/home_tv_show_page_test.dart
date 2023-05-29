import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/bloc/tv/event/tv_show_event.dart';
import 'package:ditonton/presentation/bloc/tv/state/tv_show_state.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVShowNowPlayingBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowNowPlayingBloc {}

class MockTVShowPopularBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowPopularBloc {}

class MockTVShowTopRatedBloc extends MockBloc<TVShowEvent, TVShowState>
    implements TVShowTopRatedBloc {}

class TVShowEventFake extends Fake implements TVShowEvent {}

class TVShowStateFake extends Fake implements TVShowState {}

void main() {
  late MockTVShowNowPlayingBloc mockTVShowNowPlayingBloc;
  late MockTVShowPopularBloc mockTVShowPopularBloc;
  late MockTVShowTopRatedBloc mockTVShowTopRatedBloc;

  setUp(() {
    mockTVShowNowPlayingBloc = MockTVShowNowPlayingBloc();
    mockTVShowPopularBloc = MockTVShowPopularBloc();
    mockTVShowTopRatedBloc = MockTVShowTopRatedBloc();
  });

  setUpAll(() {
    registerFallbackValue(TVShowEventFake);
    registerFallbackValue(TVShowStateFake);
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVShowNowPlayingBloc>(
          create: (context) => mockTVShowNowPlayingBloc,
        ),
        BlocProvider<TVShowPopularBloc>(
          create: (context) => mockTVShowPopularBloc,
        ),
        BlocProvider<TVShowTopRatedBloc>(
          create: (context) => mockTVShowTopRatedBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page item should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTVShowNowPlayingBloc.state).thenReturn(TVShowLoadingState());
    when(() => mockTVShowPopularBloc.state).thenReturn(TVShowLoadingState());
    when(() => mockTVShowTopRatedBloc.state).thenReturn(TVShowLoadingState());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(centerFinder, findsWidgets);
    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page item should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTVShowNowPlayingBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[]));
    when(() => mockTVShowPopularBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[]));
    when(() => mockTVShowTopRatedBloc.state)
        .thenReturn(TVShowHasDataState(result: <TV>[]));

    final listViewFinder = find.byType(ListView);
    final tvShowCardFinder = find.byType(TVShowList);

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(listViewFinder, findsWidgets);
    expect(tvShowCardFinder, findsWidgets);
  });

  testWidgets('Page item should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTVShowNowPlayingBloc.state)
        .thenReturn(TVShowErrorState(message: 'Error message'));
    when(() => mockTVShowPopularBloc.state)
        .thenReturn(TVShowErrorState(message: 'Error message'));
    when(() => mockTVShowTopRatedBloc.state)
        .thenReturn(TVShowErrorState(message: 'Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(HomeTVShowPage()));

    expect(textFinder, findsWidgets);
  });
}

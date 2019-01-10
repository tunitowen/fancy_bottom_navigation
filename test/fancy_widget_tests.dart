import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.pink,
        brightness: Brightness.light),
        home: Scaffold(
            body: Center(),
            bottomNavigationBar: child));
  }

  testWidgets('Fancy Nav has correct tabs', (WidgetTester tester) async {
    FancyBottomNavigation fn = FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.search, title: "Search")
      ],
      routeObserver: RouteObserver(),
      onTabChangedListener: (position) {},
    );

    await tester.pumpWidget(makeTestableWidget(child: fn));

    final homeFinder = find.text("Home");
    expect(homeFinder, findsOneWidget);

    final homeIconFinder = find.byIcon(Icons.home);
    expect(homeIconFinder, findsOneWidget);

    final searchIconFinder = find.byIcon(Icons.search);
    expect(searchIconFinder, findsOneWidget);

    final searchFinder = find.text("Search");
    expect(searchFinder, findsOneWidget);

    final randomFinder = find.text("Hello");
    expect(randomFinder, findsNothing);

  });
}
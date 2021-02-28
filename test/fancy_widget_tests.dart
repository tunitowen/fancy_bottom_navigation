import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
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
      onTabChangedListener: (position) {},
    );

    await tester.pumpWidget(makeTestableWidget(child: fn));

    final homeFinder = find.text("Home");
    expect(homeFinder, findsOneWidget);

    final homeIconFinder = find.byIcon(Icons.home);
    expect(homeIconFinder, findsNWidgets(2));

    final searchIconFinder = find.byIcon(Icons.search);
    expect(searchIconFinder, findsOneWidget);

    final searchFinder = find.text("Search");
    expect(searchFinder, findsOneWidget);

    final randomFinder = find.text("Hello");
    expect(randomFinder, findsNothing);

  });

  testWidgets('Clicking icon moves the circle', (WidgetTester tester) async {
    FancyBottomNavigation fn = FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.search, title: "Search")
      ],
      onTabChangedListener: (position) {},
    );

    await tester.pumpWidget(makeTestableWidget(child: fn));

    final homeFinder = find.text("Home");
    final homeIconFinder = find.byIcon(Icons.home);
    final searchIconFinder = find.byIcon(Icons.search);
    final searchFinder = find.text("Search");
    final randomFinder = find.text("Hello");

    expect(homeFinder, findsOneWidget);
    expect(homeIconFinder, findsNWidgets(2));
    expect(searchIconFinder, findsOneWidget);
    expect(searchFinder, findsOneWidget);
    expect(randomFinder, findsNothing);

    await tester.tap(searchIconFinder);
    await tester.pumpAndSettle();

    expect(searchIconFinder, findsNWidgets(2));
    expect(homeIconFinder, findsOneWidget);

  });

}
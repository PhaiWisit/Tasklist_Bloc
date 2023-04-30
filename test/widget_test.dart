import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/blocs/bloc_exports.dart';
import 'package:flutter_tasks_app/main.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';
import 'package:flutter_tasks_app/services/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  testWidgets('Widget Test', (WidgetTester tester) async {
    // Build the widget to be tested
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TabsScreen(),
        ),
      ),
    );

    // Verify that the widget has a Text widget
    expect(find.text('Completed Tasks'), findsOneWidget);

    // Verify that the widget has a specific button
    // expect(find.byKey(Key('my_button')), findsOneWidget);

    // Tap the button and trigger a rebuild of the widget
    // await tester.tap(find.byKey(Key('my_button')));
    await tester.pump();

    // Verify that the button triggered the expected behavior
    // expect(find.text('Button Pressed!'), findsOneWidget);
  });
}



class YourWidgetHere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hello, World!'),
        ElevatedButton(
          key: Key('my_button'),
          onPressed: () {},
          child: Text('Press me'),
        ),
      ],
    );
  }
}
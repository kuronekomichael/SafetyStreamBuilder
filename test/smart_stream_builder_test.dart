import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safety_stream_builder/safety_stream_builder.dart';

Widget buildTest(Stream stream, {Widget blankWidget, Widget errorWidget}) =>
    MaterialApp(
      home: SafetyStreamBuilder<String>(
        stream: stream,
        blankWidget: blankWidget,
        errorWidget: errorWidget,
        builder: (BuildContext context, String data) => Text(data),
      ),
    );

void main() {
  Stream<String> stream;
  Stream<String> errStream;

  setUp(() {
    stream = Stream<String>.fromIterable(['Hello, World.']);
    errStream = stream.map((_) => throw new Error());
  });

  testWidgets('Normal', (WidgetTester tester) async {
    // first time,
    await tester.pumpWidget(buildTest(stream));
    expect(find.byType(Container), findsOneWidget);

    await tester.pump();
    expect(find.text('Hello, World.'), findsOneWidget);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('Error', (WidgetTester tester) async {
    await tester.pumpWidget(buildTest(errStream));

    await tester.pump();
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('Set widget for blank', (WidgetTester tester) async {
    await tester.pumpWidget(buildTest(stream, blankWidget: Text('NOOOO DATA')));
    expect(find.text('NOOOO DATA'), findsOneWidget);
    expect(find.text('NO DATA'), findsNothing);

    await tester.pump();

    expect(find.text('Hello, World.'), findsOneWidget);
  });
  testWidgets('Set widget for error', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTest(errStream, errorWidget: Text('ERROR!!!!')));

    await tester.pump();
    expect(find.text('ERROR!!!!'), findsOneWidget);
  });

  testWidgets('Set default widget for blank', (WidgetTester tester) async {
    SafetyStreamBuilder.handleBlank(
        build: (BuildContext context) => Text('This is no data'));

    await tester.pumpWidget(buildTest(stream));
    expect(find.text('This is no data'), findsOneWidget);
    expect(find.text('NO DATA'), findsNothing);

    await tester.pump();

    expect(find.text('Hello, World.'), findsOneWidget);
  });

  testWidgets('Set default widget for error', (WidgetTester tester) async {
    SafetyStreamBuilder.handleBlank(
        build: (BuildContext context) => Text('This is nooooo data'));
    SafetyStreamBuilder.handleError(
        build: (BuildContext context) => Text('This is error message'));

    await tester.pumpWidget(buildTest(errStream));
    expect(find.text('This is nooooo data'), findsOneWidget);

    await tester.pump();

    expect(find.text('This is error message'), findsOneWidget);
  });
}

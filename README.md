# SafetyStreamBuilder for Flutter

[![Pub](https://img.shields.io/pub/v/safety_stream_builder.svg)](https://pub.dartlang.org/packages/safety_stream_builder) [![CircleCI](https://circleci.com/gh/kuronekomichael/SafetyStreamBuilder.svg?style=svg)](https://circleci.com/gh/kuronekomichael/SafetyStreamBuilder)

For lazy, `SafetyStreamBuilder` provide just a little safety.

## Usage

`StreamBuilder` need to finely implement whether AsyncSnapshot contains data or an error has occurred.
`SafetyStreamBuilder` provides default blank widget and error display widget and direct data. (Hiding `AsyncSnapshot`)

### Before: Using Dart standard StreamBuilder

```dart
StreamBuilder<String>(
  stream: stream,
  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }
    if (snapshot.hasError) {
      return Icon(Icons.error_outline);
    }
    return Text(snapshot.data);
  },
)
```

### After: Using SafetyStreamBuilder


```dart
SafetyStreamBuilder<String>(
  stream: stream,
  builder: (BuildContext context, String message) => Text(message),
);
```
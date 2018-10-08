# Safety StreamBuilder for Flutter

For lazy, `SafetyStreamBuilder` can use with just a little confidence.

## Usage

In `StreamBuilder`, it is necessary to finely implement whether AsyncSnapshot contains data or an error has occurred.
`SafetyStreamBuilder` provides default blank widget and error display widget and direct data. (hiding `AsyncSnapshot`)

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
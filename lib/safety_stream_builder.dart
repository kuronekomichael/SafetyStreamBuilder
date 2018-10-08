library safety_stream_builder;

import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget AsyncWidgetSafetyBuilder<T>(BuildContext context, T data);

typedef Widget BuildHandler(BuildContext context);

class SafetyStreamBuilder<T> extends StreamBuilder<T> {
  static BuildHandler _buildErrorWidget = (_) => Icon(Icons.error_outline);
  static BuildHandler _buildBlankWidget = (_) => Container();

  static void handleError({@required BuildHandler build}) =>
      _buildErrorWidget = build;

  static void handleBlank({@required BuildHandler build}) =>
      _buildBlankWidget = build;

  final AsyncWidgetSafetyBuilder<T> _builder;
  final Widget blankWidget;
  final Widget errorWidget;

  factory SafetyStreamBuilder({
    @required AsyncWidgetSafetyBuilder<T> builder,
    Key key,
    T initialData,
    Stream<T> stream,
    Widget blankWidget,
    Widget errorWidget,
  }) =>
      SafetyStreamBuilder._(
        builder: builder,
        unusedBuilder: (_, __) => null, // dummy
        key: key,
        initialData: initialData,
        stream: stream,
        blankWidget: blankWidget,
        errorWidget: errorWidget,
      );

  const SafetyStreamBuilder._({
    @required AsyncWidgetSafetyBuilder<T> builder,
    @required AsyncWidgetBuilder<T> unusedBuilder,
    Key key,
    T initialData,
    Stream<T> stream,
    this.blankWidget,
    this.errorWidget,
  })  : _builder = builder,
        super(
          key: key,
          initialData: initialData,
          stream: stream,
          builder: unusedBuilder,
        );

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) {
      return errorWidget != null ? errorWidget : _buildErrorWidget(context);
    }
    if (!snapshot.hasData) {
      return blankWidget != null ? blankWidget : _buildBlankWidget(context);
    }
    return _builder(context, snapshot.data);
  }
}

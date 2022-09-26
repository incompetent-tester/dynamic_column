import 'package:flutter/material.dart';

class BoardThemeData {
  final MaterialColor resizeHandlerColor;
  final double resizeHandlerOpacity;

  final MaterialColor enabledBorderColor;
  final double enabledBorderWidth;

  final Icon removeIcon;

  final EdgeInsets margin;

  final Icon moveIcon;

  const BoardThemeData({
    this.resizeHandlerColor = Colors.grey,
    this.resizeHandlerOpacity = 0.5,

    //
    this.enabledBorderColor = Colors.grey,
    this.enabledBorderWidth = 5.0,

    //
    this.margin = const EdgeInsets.all(5.0),

    //
    this.removeIcon = const Icon(Icons.close),

    //
    this.moveIcon = const Icon(Icons.all_out, size: 48),
  });
}

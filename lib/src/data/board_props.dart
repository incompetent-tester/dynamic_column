import 'dart:convert';

class BoardXY {
  final double x;
  final double y;

  const BoardXY({this.x = 0, this.y = 0});

  BoardXY.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };
}

class BoardProps {
  BoardXY pos;

  double width;
  double height;

  final String id;
  final bool resizable;

  BoardProps({
    required this.id,
    this.pos = const BoardXY(),
    this.width = 1.0,
    this.height = 1.0,
    this.resizable = true,
  });

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BoardProps //
        ? other.id == id
        : other == id;
  }

  BoardProps.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        id = json['id'],
        pos = BoardXY.fromJson(json['pos']),
        resizable = json['resizable'];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'id': id,
        'pos': jsonEncode(pos),
        'resizable': resizable,
      };
}

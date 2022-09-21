import 'dart:convert';

class BoardXY {
  final int x;
  final int y;

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

  int width;
  int height;

  final String id;

  BoardProps({
    required this.id,
    this.pos = const BoardXY(),
    this.width = 1,
    this.height = 1,
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
        pos = BoardXY.fromJson(json['pos']);

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'id': id,
        'pos': jsonEncode(pos),
      };
}

class BoardXY {
  final int x;
  final int y;

  const BoardXY({this.x = 0, this.y = 0});
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
}

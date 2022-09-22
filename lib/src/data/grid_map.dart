import 'dart:collection';

import 'package:dynamic_board/src/data/board_props.dart';

///
/// Quad Tree Implementation
///
class GridMap {
  final _setYDir = SplayTreeSet<BoardProps>((a, b) => (a.pos.y + a.height) - (b.pos.y + b.height));

  void insert(BoardProps props) {
    _setYDir.add(props);
  }

  void delete(BoardProps props) {
    _setYDir.remove(props);
  }

  void refresh(BoardProps props) {
    delete(props);
    insert(props);
  }

  int maxY() {
    if (_setYDir.isNotEmpty) {
      var l = _setYDir.last;
      return l.pos.y + l.height;
    } else {
      return 0;
    }
  }
}

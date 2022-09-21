import 'package:dynamic_board/src/board_item.dart';
import 'package:dynamic_board/src/data/board_props.dart';
import 'package:dynamic_board/src/data/board_theme_data.dart';
import 'package:dynamic_board/src/data/grid_map.dart';
import 'package:dynamic_board/src/components/inner_board_item.dart';
import 'package:flutter/material.dart';

class DynamicBoard extends StatefulWidget {
  final List<BoardItem> items;
  final Set<BoardProps> props;
  final BoardThemeData themeData;

  final bool editable;
  final VoidCallback? onDelete;

  const DynamicBoard({
    super.key,
    required this.items,
    required this.props,
    required this.editable,
    this.onDelete,
    this.themeData = const BoardThemeData(),
  });

  @override
  State<StatefulWidget> createState() => _DynamicBoardState();
}

class _DynamicBoardState extends State<DynamicBoard> {
  final int _mobileSection = 3;
  final int _tabletSection = 6;

  final _scrollController = ScrollController();
  final _gridMap = GridMap();

  var _mobileLayout = true;
  var _disableScroll = false;
  var _gridSize = 0.0;

  @override
  void initState() {
    super.initState();

    for (var e in widget.props) {
      _gridMap.insert(e);
    }
  }

  void _calculateGridSize(BuildContext context, BoxConstraints constraints) {
    final query = MediaQuery.of(context);

    _mobileLayout = query.size.shortestSide < 700;
    _gridSize = _mobileLayout //
        ? constraints.maxWidth / _mobileSection
        : constraints.maxWidth / _tabletSection;
  }

  @override
  Widget build(BuildContext context) {
    /* --------------------------------- Render --------------------------------- */
    return LayoutBuilder(builder: (context, constraint) {
      return OrientationBuilder(
        builder: (BuildContext context, _) {
          _calculateGridSize(context, constraint);

          return SingleChildScrollView(
            controller: _scrollController,
            physics: _disableScroll //
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            child: SizedBox(
              height: _gridMap.maxY() * _gridSize * 1.1,
              child: Stack(
                children: widget.items.map(
                  (e) {
                    final props = widget.props.lookup(BoardProps(id: e.id));
                    assert(props != null, "Missing props for ${e.id} BoardItem");

                    return InnerBoardItem(
                      onDelete: widget.onDelete,
                      themeData: widget.themeData,
                      editable: widget.editable,
                      scrollCtrlRef: _scrollController,
                      boardItem: e,
                      gridSize: _gridSize,
                      height: props!.height,
                      width: props.width,
                      pos: props.pos,
                      onDrag: (dragEnabled) {
                        setState(() {
                          _disableScroll = dragEnabled;
                        });
                      },
                      onDragMove: (x, y) {
                        setState(() {
                          props.pos = BoardXY(x: x, y: y);
                          _gridMap.refresh(props);
                        });
                      },
                      onResizeW: (w) {
                        setState(() {
                          props.width = w;
                          _gridMap.refresh(props);
                        });
                      },
                      onResizeH: (h) {
                        setState(() {
                          props.height = h;
                          _gridMap.refresh(props);
                        });
                      },
                      onResizeMoveW: (x, w) {
                        setState(() {
                          props.pos = BoardXY(x: x, y: props.pos.y);
                          props.width = w;
                          _gridMap.refresh(props);
                        });
                      },
                      onResizeMoveH: (y, h) {
                        setState(() {
                          props.pos = BoardXY(x: props.pos.x, y: y);
                          props.height = h;
                          _gridMap.refresh(props);
                        });
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          );
        },
      );
    });
  }
}

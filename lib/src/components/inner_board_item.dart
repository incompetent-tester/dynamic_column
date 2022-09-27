import 'package:dynamic_board/dynamic_board.dart';
import 'package:dynamic_board/src/components/move_resize_container.dart';
import 'package:dynamic_board/src/data/board_theme_data.dart';
import 'package:flutter/material.dart';

class InnerBoardItem extends StatefulWidget {
  final BoardItem boardItem;
  final BoardThemeData themeData;
  final double gridSize;

  final BoardProps props;

  final VoidCallback? onDelete;
  final Function(bool) onDrag;
  final Function(double, double) onDragMove;

  final Function(double, double) onResizeMoveW;
  final Function(double, double) onResizeMoveH;

  final Function(double) onResizeW;
  final Function(double) onResizeH;

  final bool editMode;

  final GlobalKey parentKey;

  const InnerBoardItem({
    super.key,
    required this.editMode,
    required this.boardItem,
    required this.themeData,
    required this.gridSize,
    required this.props,
    required this.onDrag,
    required this.onDragMove,
    required this.onResizeMoveW,
    required this.onResizeMoveH,
    required this.onResizeW,
    required this.onResizeH,
    required this.parentKey,
    this.onDelete,
  });

  @override
  State<StatefulWidget> createState() => _InnerBoardItemState();
}

class _InnerBoardItemState extends State<InnerBoardItem> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromLTWH(
        widget.props.pos.x * widget.gridSize,
        widget.props.pos.y * widget.gridSize,
        widget.props.width * widget.gridSize,
        widget.props.height * widget.gridSize,
      ),
      child: Container(
        height: widget.props.height * widget.gridSize,
        width: widget.props.width * widget.gridSize,
        margin: widget.themeData.margin,
        child: MoveResizeContainer(
          parentKey: widget.parentKey,
          themeData: widget.themeData,
          editMode: widget.editMode,
          resizable: widget.props.resizable,
          onDrag: widget.onDrag,
          onDragMove: widget.onDragMove,
          onResizeR: (x) {
            var w = x - widget.props.pos.x;
            widget.onResizeW(w < 1 ? 1 : w);
          },
          onResizeB: (y) {
            var h = y - widget.props.pos.y;
            widget.onResizeH(h < 1 ? 1 : h);
          },
          onResizeL: (x) {
            var dx = widget.props.pos.x - x;
            var newWidth = widget.props.width + dx;

            widget.onResizeMoveW(x, newWidth < 0 ? 1 : newWidth);
          },
          onResizeT: (y) {
            var dy = widget.props.pos.y - y;
            var newHeight = widget.props.height + dy;
            widget.onResizeMoveH(y, newHeight < 0 ? 1 : newHeight);
          },
          gridSize: widget.gridSize,
          containerH: widget.props.height,
          containerW: widget.props.width,
          child: widget.editMode
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.themeData.enabledBorderColor,
                          width: widget.themeData.enabledBorderWidth,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: widget.boardItem.child,
                    ),

                    // Delete options
                    if (widget.onDelete != null)
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            widget.onDelete?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: widget.themeData.removeIcon,
                          ),
                        ),
                      )
                  ],
                )
              : widget.boardItem.child,
        ),
      ),
    );
  }
}

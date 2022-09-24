import 'package:dynamic_board/dynamic_board.dart';
import 'package:dynamic_board/src/components/move_resize_container.dart';
import 'package:dynamic_board/src/data/board_theme_data.dart';
import 'package:flutter/material.dart';

class InnerBoardItem extends StatefulWidget {
  final BoardItem boardItem;
  final BoardThemeData themeData;
  final double gridSize;

  final BoardXY pos;

  final double height;
  final double width;

  final VoidCallback? onDelete;
  final Function(bool) onDrag;
  final Function(double, double) onDragMove;

  final Function(double, double) onResizeMoveW;
  final Function(double, double) onResizeMoveH;

  final Function(double) onResizeW;
  final Function(double) onResizeH;

  final ScrollController scrollCtrlRef;
  final bool editable;

  const InnerBoardItem({
    super.key,
    required this.editable,
    required this.boardItem,
    required this.themeData,
    required this.gridSize,
    required this.pos,
    required this.height,
    required this.width,
    required this.onDrag,
    required this.onDragMove,
    required this.onResizeMoveW,
    required this.onResizeMoveH,
    required this.onResizeW,
    required this.onResizeH,
    required this.scrollCtrlRef,
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
        widget.pos.x * widget.gridSize,
        widget.pos.y * widget.gridSize,
        widget.width * widget.gridSize,
        widget.height * widget.gridSize,
      ),
      child: Container(
        margin: widget.themeData.margin,
        child: MoveResizeContainer(
          themeData: widget.themeData,
          editable: widget.editable,
          scrollCtrlRef: widget.scrollCtrlRef,
          onDrag: widget.onDrag,
          onDragMove: widget.onDragMove,
          onResizeR: (x) {
            var w = x - widget.pos.x;
            widget.onResizeW(w < 1 ? 1 : w);
          },
          onResizeB: (y) {
            var h = y - widget.pos.y;
            widget.onResizeH(h < 1 ? 1 : h);
          },
          onResizeL: (x) {
            var dx = widget.pos.x - x;
            var newWidth = widget.width + dx;

            widget.onResizeMoveW(x, newWidth < 0 ? 1 : newWidth);
          },
          onResizeT: (y) {
            var dy = widget.pos.y - y;
            var newHeight = widget.height + dy;
            widget.onResizeMoveH(y, newHeight < 0 ? 1 : newHeight);
          },
          gridSize: widget.gridSize,
          containerH: widget.height,
          containerW: widget.width,
          child: widget.editable
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
                          ))
                  ],
                )
              : widget.boardItem.child,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:dynamic_board/src/data/board_theme_data.dart';
import 'package:flutter/material.dart';

class MoveResizeContainer extends StatefulWidget {
  final Widget child;

  final bool editable;
  final Function(bool) onDrag;
  final Function(int, int) onDragMove;

  final Function(int) onResizeL;
  final Function(int) onResizeT;

  final Function(int) onResizeR;
  final Function(int) onResizeB;

  final ScrollController scrollCtrlRef;

  final double gridSize;
  final int containerW;
  final int containerH;

  final BoardThemeData themeData;

  const MoveResizeContainer({
    super.key,
    required this.scrollCtrlRef,
    required this.editable,
    required this.child,
    required this.onDrag,
    required this.onDragMove,
    required this.onResizeL,
    required this.onResizeT,
    required this.onResizeR,
    required this.onResizeB,
    required this.containerW,
    required this.containerH,
    required this.gridSize,
    required this.themeData,
  });

  @override
  State<StatefulWidget> createState() => _MoveResizeContainerState();
}

class _MoveResizeContainerState extends State<MoveResizeContainer> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildResizerLT({
    required Alignment align,
  }) {
    return Align(
      alignment: align,
      child: GestureDetector(
        // For top and bottom
        onVerticalDragStart: align == Alignment.topCenter
            ? (details) {
                widget.onDrag(true);
              }
            : null,
        onVerticalDragUpdate: align == Alignment.topCenter
            ? (details) {
                int y = (details.globalPosition.dy / widget.gridSize).floor();
                widget.onResizeT(y);
              }
            : null,
        onVerticalDragEnd: align == Alignment.topCenter
            ? (details) {
                widget.onDrag(false);
              }
            : null,

        // For left and right
        onHorizontalDragStart: align == Alignment.centerLeft
            ? (details) {
                widget.onDrag(true);
              }
            : null,
        onHorizontalDragUpdate: align == Alignment.centerLeft
            ? (details) {
                int x = (details.globalPosition.dx / widget.gridSize).round();
                widget.onResizeL(x);
              }
            : null,
        onHorizontalDragEnd: align == Alignment.centerLeft
            ? (details) {
                widget.onDrag(true);
              }
            : null,

        // Render
        child: Container(
          color: widget.themeData.resizeHandlerColor.withOpacity(widget.themeData.resizeHandlerOpacity),
          height: align == Alignment.centerLeft ? widget.gridSize * 0.8 : widget.gridSize * 0.2,
          width: align == Alignment.topCenter ? widget.gridSize * 0.8 : widget.gridSize * 0.2,
        ),
      ),
    );
  }

  Widget _buildResizerRB({
    required Alignment align,
  }) {
    return Align(
      alignment: align,
      child: GestureDetector(
        // For top and bottom
        onVerticalDragStart: align == Alignment.bottomCenter
            ? (details) {
                widget.onDrag(true);
              }
            : null,
        onVerticalDragUpdate: align == Alignment.bottomCenter
            ? (details) {
                int y = ((details.globalPosition.dy + widget.scrollCtrlRef.offset) / widget.gridSize).round();
                widget.onResizeB(y);
              }
            : null,
        onVerticalDragEnd: align == Alignment.bottomCenter
            ? (details) {
                widget.onDrag(false);
              }
            : null,

        // For left and right
        onHorizontalDragStart: align == Alignment.centerRight
            ? (details) {
                widget.onDrag(true);
              }
            : null,
        onHorizontalDragUpdate: align == Alignment.centerRight
            ? (details) {
                int x = (details.globalPosition.dx / widget.gridSize).round();
                widget.onResizeR(x);
              }
            : null,
        onHorizontalDragEnd: align == Alignment.centerRight
            ? (details) {
                widget.onDrag(true);
              }
            : null,

        // Render
        child: Container(
          color: widget.themeData.resizeHandlerColor.withOpacity(widget.themeData.resizeHandlerOpacity),
          height: align == Alignment.centerRight ? widget.gridSize * 0.8 : widget.gridSize * 0.2,
          width: align == Alignment.bottomCenter ? widget.gridSize * 0.8 : widget.gridSize * 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        widget.onDrag(true);
      },
      onLongPressMoveUpdate: (details) {
        if (widget.editable) {
          int x = (details.globalPosition.dx / widget.gridSize - widget.containerW / 2).round();
          int y = ((details.globalPosition.dy + widget.scrollCtrlRef.offset) / widget.gridSize - widget.containerH / 2).round();

          widget.onDragMove(x, y);
        }
      },
      onLongPressEnd: (_) {
        widget.onDrag(false);
      },
      child: Stack(
        children: [
          widget.child,

          //
          if (widget.editable) _buildResizerRB(align: Alignment.centerRight),

          //
          if (widget.editable) _buildResizerLT(align: Alignment.centerLeft),

          //
          if (widget.editable) _buildResizerRB(align: Alignment.bottomCenter),

          //
          if (widget.editable) _buildResizerLT(align: Alignment.topCenter),
        ],
      ),
    );
  }
}

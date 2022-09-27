import 'dart:async';
import 'dart:math';

import 'package:dynamic_board/src/data/board_theme_data.dart';
import 'package:flutter/material.dart';

class MoveResizeContainer extends StatefulWidget {
  final Widget child;

  final bool editMode;
  final bool resizable;
  final Function(bool) onDrag;
  final Function(double, double) onDragMove;

  final Function(double) onResizeL;
  final Function(double) onResizeT;

  final Function(double) onResizeR;
  final Function(double) onResizeB;

  final double gridSize;
  final double containerW;
  final double containerH;

  final BoardThemeData themeData;

  final GlobalKey parentKey;

  const MoveResizeContainer({
    super.key,
    required this.editMode,
    required this.resizable,
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
    required this.parentKey,
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

  // Offset with respect to parent / root widget
  Offset _relativeOffset(Offset global) {
    final renderBox = widget.parentKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(global);
  }

  double _snap(double input) {
    return (input * 10).round() / 10;
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
                final pos = _relativeOffset(details.globalPosition);
                final dy = pos.dy;

                double y = _snap(dy / widget.gridSize);
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
                final pos = _relativeOffset(details.globalPosition);
                final dx = pos.dx;

                double x = _snap(dx / widget.gridSize);
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
                final pos = _relativeOffset(details.globalPosition);

                final dy = pos.dy;

                double y = _snap(dy / widget.gridSize);
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
                final pos = _relativeOffset(details.globalPosition);
                final dx = pos.dx;

                double x = _snap(dx / widget.gridSize);
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

  Widget _buildMove() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTapDown: (details) {
            widget.onDrag(true);
          },
          onTapUp: (_) {
            widget.onDrag(false);
          },
          onPanUpdate: (details) {
            if (widget.editMode) {
              final pos = _relativeOffset(details.globalPosition);

              final dx = pos.dx;
              final dy = pos.dy;

              double x = dx / widget.gridSize - widget.containerW / 2;
              double y = (dy / widget.gridSize - widget.containerH / 2);

              widget.onDragMove(_snap(x), _snap(y));
            }
          },
          onPanEnd: (_) {
            widget.onDrag(false);
          },
          behavior: HitTestBehavior.opaque,
          child: Transform.rotate(
            angle: pi / 4,
            child: widget.themeData.moveIcon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (widget.editMode) _buildMove(),

        //
        if (widget.editMode && widget.resizable) _buildResizerRB(align: Alignment.centerRight),

        //
        if (widget.editMode && widget.resizable) _buildResizerLT(align: Alignment.centerLeft),

        //
        if (widget.editMode && widget.resizable) _buildResizerRB(align: Alignment.bottomCenter),

        //
        if (widget.editMode && widget.resizable) _buildResizerLT(align: Alignment.topCenter),
      ],
    );
  }
}

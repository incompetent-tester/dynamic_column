import 'package:flutter/material.dart';

class BoardItem extends StatelessWidget {
  final String id;

  final Widget child;

  const BoardItem({
    super.key,
    required this.id,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

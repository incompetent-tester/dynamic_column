import 'package:flutter/material.dart';
import 'package:dynamic_board/dynamic_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _editable = false;
  final _props = {
    BoardProps(id: "item_1", pos: const BoardXY(x: 0, y: 0)),
    BoardProps(id: "item_2", pos: const BoardXY(x: 4.0, y: 3.0), height: 2, width: 2, resizable: false),
    BoardProps(id: "item_3", pos: const BoardXY(x: 2.0, y: 0.0), resizable: false),
    BoardProps(id: "item_4", pos: const BoardXY(x: 2.0, y: 6.0), height: 2, width: 2, resizable: false),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: _editable //
              ? const Icon(Icons.close)
              : const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _editable = !_editable;
            });
          },
        ),
        body: DynamicBoard(
          editMode: _editable,
          onDelete: () {},
          items: [
            BoardItem(
              id: "item_1",
              child: Container(
                color: Colors.red,
              ),
            ),
            BoardItem(
              id: "item_2",
              child: Container(
                color: Colors.blue,
              ),
            ),
            BoardItem(
              id: 'item_3',
              child: Card(
                color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text("This is a test card.")
                  ],
                ),
              ),
            ),
            BoardItem(
              id: "item_4",
              child: Container(
                color: Colors.amberAccent,
              ),
            ),
          ],
          props: _props,
        ),
      ),
    );
  }
}

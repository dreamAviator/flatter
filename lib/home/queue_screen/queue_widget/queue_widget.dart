import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class QueueWidget extends StatefulWidget {
  const QueueWidget({super.key});

  @override
  State<QueueWidget> createState() => _QueueWidgetState();
}

class _QueueWidgetState extends State<QueueWidget> {
  List<List<dynamic>> _items = playerControl.getQueue();
  int currentIndex = playerControl.getCurrentIndex();

  void updateQueue(int oldIndex,int newIndex) {
    playerControl.moveItem(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: true,
      children: [
        for (int index = 0; index < _items.length; index += 1)
          if (index == currentIndex)
            Card.filled(
              key: Key('$index'),
              child: Column(
                children: [
                  Slidable(
                    startActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => ,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(//hier zu album und zu artist
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(

                        ),
                        SlidableAction(

                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(_items[index][1][0]),
                      subtitle: Text(_items[index][1][1]),
                    ),
                  )
                ],
              ),
            ) else
            Card(
                key: Key('$index'),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(_items[index][1][0]),
                      subtitle: Text(_items[index][1][1]),
                    ),
                  ],
                ),
            ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          updateQueue(oldIndex, newIndex);
          _items = playerControl.getQueue();
          currentIndex = playerControl.getCurrentIndex();
        });
      },
    );
  }
}
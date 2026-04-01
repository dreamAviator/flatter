import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/itemMenus.dart';
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

    void removeFromQueue(String id) {

    }
    void goToAlbum(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: id,)));
    }
    void goToArtist(BuildContext context, String id) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: id)));
    }

    print("items now");
    print(_items);
    return ReorderableListView(//ich glaube hier wolltest du sowieso was anderes suchen
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
                          onPressed: (_) => (removeFromQueue(_items[index][0])),
                          icon: Icons.delete,
                          label: 'Delete',
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(//farben überlegen
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => (goToAlbum(context, _items[index][1][4])),
                          icon: Icons.album,
                          label: 'Album',
                        ),
                        SlidableAction(
                          onPressed: (_) => (goToArtist(context, _items[index][1][2])),
                          icon: Icons.person,
                          label: 'Artist',
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(_items[index][1][0]),
                      subtitle: Text(_items[index][1][1]),
                      trailing: ItemMenus(context).songMenu(_items[index][0], _items[index][1][2], _items[index][1][4]),
                    ),
                  ),
                ],
              ),
            ) else
            Card(
                key: Key('$index'),
                child: Column(
                  children: [
                    Slidable(
                      startActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => (removeFromQueue(_items[index][0])),
                            icon: Icons.delete,
                            label: 'Delete',
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(//farben überlegen
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => (goToAlbum(context, _items[index][1][4])),
                            icon: Icons.album,
                            label: 'Album',
                          ),
                          SlidableAction(
                            onPressed: (_) => (goToArtist(context, _items[index][1][2])),
                            icon: Icons.person,
                            label: 'Artist',
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(_items[index][1][0]),
                        subtitle: Text(_items[index][1][1]),
                        trailing: ItemMenus(context).songMenu(_items[index][0], _items[index][1][2], _items[index][1][4]),//aus dem hier eine checkbox machen wenn man dinge selected
                      ),
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
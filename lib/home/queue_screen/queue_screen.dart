import 'package:flatter/home/queue_screen/queue_screen_ViewModel.dart';
import 'package:flatter/home/queue_screen/queue_widget/queue_widget.dart';
import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key,required this.viewModel});
  final QueueScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: QueueWidget()),
          Divider(),
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,//farbe auswählen (generell halt wenn du dich um die farben kümmerst
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,//ig besser als space around
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.playlist_add),
                ),
                IconButton(
                  onPressed: () {
                    playerControl.shuffleQueue();
                  },
                  icon: Icon(Icons.shuffle),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.loop),//hier halt single und ganze queue
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.search),//search und evt animation selbst bauen qwq
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
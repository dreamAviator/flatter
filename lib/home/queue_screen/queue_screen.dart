import 'package:flatter/home/queue_screen/queue_screen_ViewModel.dart';
import 'package:flatter/home/queue_screen/queue_widget/queue_widget.dart';
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
            color: Colors.primaries[1],//farbe auswählen (generell halt wenn du dich um die farben kümmerst
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.transfer_within_a_station),
                )
              ],
            ),
          ),
        ],
      ),//hier eine bottom bar hinzufügen, um playlist controls anzuzeigen
    );
  }
}
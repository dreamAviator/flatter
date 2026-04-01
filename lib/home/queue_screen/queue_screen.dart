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
      body: QueueWidget(),//hier eine bottom bar hinzufügen, um playlist controls anzuzeigen
    );
  }
}
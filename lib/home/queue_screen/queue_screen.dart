import 'package:flatter/home/queue_screen/queue_screen_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key,required this.viewModel});
  final QueueScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("queue screen"),
    );
  }
}
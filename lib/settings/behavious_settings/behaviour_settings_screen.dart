import 'package:flutter/material.dart';

class BehaviourSettingsScreen extends StatelessWidget {
  const BehaviourSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Behaviour Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
//hier halt jtz das ding mit startpage bspw
        ],
      ),
    );
  }
}
import 'package:flatter/home/player_screen/play_button.dart';
import 'package:flatter/home/player_screen/player_screen_ViewModel.dart';
import 'package:flutter/material.dart';

import '../../settings/settings_screen.dart';
import '../../settings/settings_screen_ViewModel.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key,required this.viewModel});
  final PlayerScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("playing song..."),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(viewModel: SettingsScreenViewmodel())));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton.filledTonal(onPressed: viewModel.rewind, icon: Icon(Icons.fast_rewind)),
              PlayButton(),
              IconButton.filledTonal(onPressed: viewModel.skip, icon: Icon(Icons.fast_forward_rounded)),
            ],
          ),
        ],
      ),
    );
  }
}
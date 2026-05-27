import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/player_screen/play_button.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/settings_screen.dart';
import '../../settings/settings_screen_ViewModel.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    RiverpodManager riverpodManager = RiverpodManager();
    return Consumer(
      builder: (context,ref,child) {
        final playData = ref.watch(riverpodManager.playerUiProvider);
        if (settingsControl.loadSetting('landscapeMode') == true) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  spacing: 12,
                  children: [
                    Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("lib/assets/images/empty_player.png",height: screenSize.width / 3,),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {

                              },
                              child: Text("Title"),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: Text("Album"),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: Text("Artist"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 12,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Text("hier lyrics und mehr"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [//diese knöpfe sollte man austauschen können, vlt auch auswählen wie viele
                                  IconButton(
                                    icon: Icon(Icons.repeat),
                                    onPressed: () {

                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.fast_rewind),
                                    onPressed: () {
                                      playerControl.skipToQueueItem(0);
                                      //playerControl.skipToPrevious();//TODO:nur wenn mehr als [zeit] überschritten wurde (in den einstellungen zeit einstellen)
                                    },
                                  ),
                                  PlayButton(),
                                  IconButton(
                                    icon: Icon(Icons.fast_forward),
                                    onPressed: () {
                                      playerControl.skipToNext();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shuffle),
                                    onPressed: () {
                                      playerControl.customAction('shuffleQueue');
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text("hier der slider"),
            ],
          );
        } else {
          return Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset("lib/assets/images/empty_player.png",height: screenSize.width - 16,),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {

                          },
                          child: Text("Title"),
                        ),
                        TextButton(
                          onPressed: () {

                          },
                          child: Text("Album"),
                        ),
                        TextButton(
                          onPressed: () {

                          },
                          child: Text("Artist"),
                        ),
                      ],
                    ),
                  ],
                ),//minus das padding auf beiden sieten halt
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 12,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.fast_rewind),
                          onPressed: () {

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.fast_forward),
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                    Text("hier der slider")
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
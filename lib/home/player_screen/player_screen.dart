import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flatter/home/library_screen/album_screen/album_screen.dart';
import 'package:flatter/home/library_screen/artist_screen/artist_screen.dart';
import 'package:flatter/home/library_screen/artist_select_window.dart';
import 'package:flatter/home/player_screen/player_image.dart';
import 'package:flatter/home/player_screen/play_button.dart';
import 'package:flatter/home/player_screen/progess_slider.dart';
import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    RiverpodManager riverpodManager = RiverpodManager();
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
                    PlayerImage(height: screenSize.width / 3),
                    StreamBuilder(
                      stream: playerControl.mediaItem,
                      builder: (context, asyncSnapshot) {
                        final String title = asyncSnapshot.data?.title ?? "Unknown";
                        final String album = asyncSnapshot.data?.album ?? "Unknown";
                        final String artist = asyncSnapshot.data?.artist ?? "Unknown";
                        final String? albumID = asyncSnapshot.data?.extras?['albumId'];
                        final String? artistID = asyncSnapshot.data?.extras?['artistId'];
                        final List? artists = asyncSnapshot.data?.extras?['artists'];
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                //hier vlt noch was hinzufügen
                              },
                              child: Text(title),
                            ),
                            if (albumID == null) Text(album),
                            if (albumID != null) TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
                              },
                              child: Text(album),
                            ),
                            if (artistID == null) Text(album),
                            if (artistID != null) TextButton(
                              onPressed: () {
                                if (artists?.length == 1 || artists == null) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
                                } else {
                                  ArtistSelectWindow.showArtistSelectWindow(context, artists);
                                }
                              },
                              child: Text(artist),
                            ),
                          ],
                        );
                      }
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
                                  AudioService.position.listen((Duration position) {
                                    if (position.inSeconds >= settingsControl.loadSetting('timeUntilSeekToStart') && settingsControl.loadSetting('timeUntilSeekToStart') != -1) {
                                      playerControl.seek(Duration.zero);
                                    } else {
                                      playerControl.skipToPrevious();
                                    }
                                  });
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
                                  playerControl.customAction('shuffleQueue');//das soll vermutlich eig was anderes machen, aber ich checke highkey den shuffle modus bei den anderen prorgammen nicht. wozu?
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
          ProgressSlider(),
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
                PlayerImage(height: screenSize.width - 16),
                StreamBuilder(
                  stream: playerControl.mediaItem,
                  builder: (context, asyncSnapshot) {
                    final String title = asyncSnapshot.data?.title ?? "Unknown";
                    final String album = asyncSnapshot.data?.album ?? "Unknown";
                    final String artist = asyncSnapshot.data?.artist ?? "Unknown";
                    final String? albumID = asyncSnapshot.data?.extras?['albumId'];//TODO:hier natürlich auch den artist chooser ausführen später
                    final String? artistID = asyncSnapshot.data?.extras?['artistId'];
                    return Column(
                      children: [
                        TextButton(
                          onPressed: () {
                    //hier vlt noch was hinzufügen
                          },
                          child: Text(title),
                        ),
                        if (albumID == null) Text(album),
                        if (albumID != null) TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumID)));
                          },
                          child: Text(album),
                        ),
                        if (artistID == null) Text(album),
                        if (artistID != null) TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistID)));
                          },
                          child: Text(artist),
                        ),
                      ],
                    );
                  }
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
                        AudioService.position.listen((Duration position) {
                          if (position.inSeconds < settingsControl.loadSetting('timeUntilSeekToStart')) {
                            playerControl.seek(Duration.zero);
                          } else {
                            playerControl.skipToPrevious();
                          }
                        });
                      },
                    ),
                    PlayButton(),
                    IconButton(
                      icon: Icon(Icons.fast_forward),
                      onPressed: () {
                        playerControl.skipToNext();
                      },
                    ),
                  ],
                ),
                ProgressSlider(),
              ],
            ),
          ),
        ],
      );
    }
  }
}
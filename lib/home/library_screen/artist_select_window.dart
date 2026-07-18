import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Riverpod/riverpod_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_card/image_card.dart';

import 'artist_screen/artist_screen.dart';

class ArtistSelectWindow {//TODO:joa das hier machen nh :P
  static void showArtistSelectWindow(BuildContext context,List<dynamic> artistIDs) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: artistIDs.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(artistIDs[index]['name']),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: artistIDs[index]['id'])));
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    );
  }
}
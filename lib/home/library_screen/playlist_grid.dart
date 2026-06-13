import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/library_screen/playlist_screen/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';
import 'itemMenus.dart';

class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({super.key,required this.playlistListNullable,required this.crossAxisCount,required this.sliver,this.onlyOwn});
  final List<dynamic>? playlistListNullable;
  final int crossAxisCount;
  final bool sliver;
  final bool? onlyOwn;

  @override
  Widget build(BuildContext context) {
    List<dynamic> playlistList = [];
    if (playlistListNullable != null && playlistListNullable?.isEmpty == false) {
      for (Map playlist in playlistListNullable!) {
        print(playlist);
      }
      print(playlistListNullable);
      playlistList.addAll(playlistListNullable!);
    } else {
      if (sliver == true) {
        return SliverToBoxAdapter(
          child: Center(child: Text("No songs")),
        );
      } else {
        return Center(child: Text("No songs"));
      }
    }
    if (onlyOwn == true) {
      playlistList.removeWhere((item) {
        if (item['owner'] != databaseControl.getCurrentUsername()) {
          return true;
        }
        return false;
      });
    } else if (onlyOwn == false) {
      playlistList.removeWhere((item) {
        if (item['owner'] == databaseControl.getCurrentUsername()) {
          return true;
        }
        return false;
      });
    }
    if (playlistList.isEmpty) {
      if (sliver == true) {
        return SliverToBoxAdapter(
          child: Center(child: Text("No songs")),
        );
      } else {
        return Center(child: Text("No songs"));
      }
    }
    if (sliver == true) {
      return SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        childCount: playlistList.length,
        itemBuilder: (context, index) {
          Map item = playlistList[index];
          if (onlyOwn == true) {
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print("playlost tapped");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PlaylistScreen(playlistID: item['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(
                            null, null, null)[0]}getCoverArt${subsonicService
                            .getURL(
                            null, null, null)[1]}&id=${item['coverArt']}",
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) =>
                            IconButton(
                              onPressed: () {
                                //hier retry
                              },
                              icon: Icon(Icons.error),
                            ),
                      ),
                    ),
                    ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['songCount'].toString()),
                      trailing: ItemMenus(context).playlistMenuList(item),
                    ),
                  ],
                ),
              ),
            );
          }
          return Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlist tabbed");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: item['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${item['coverArt']}",
                      progressIndicatorBuilder: (context, url,
                          downloadProgress) =>
                          LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context, url, error) =>
                          IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(item['name']),
                    subtitle: Text(item['owner']),
                    trailing: ItemMenus(context).playlistMenuList(item),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return MasonryGridView.count(
        crossAxisCount: crossAxisCount,
        itemCount: playlistList.length,
        itemBuilder: (context, index) {
          Map item = playlistList[index];
          if (onlyOwn == true) {
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print("playlost tapped");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PlaylistScreen(playlistID: item['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(
                            null, null, null)[0]}getCoverArt${subsonicService
                            .getURL(
                            null, null, null)[1]}&id=${item['coverArt']}",
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) =>
                            IconButton(
                              onPressed: () {
                                //hier retry
                              },
                              icon: Icon(Icons.error),
                            ),
                      ),
                    ),
                    ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['songCount'].toString()),
                      trailing: ItemMenus(context).playlistMenuList(item),
                    ),
                  ],
                ),
              ),
            );
          }
          return Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlist tabbed");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: item['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${item['coverArt']}",
                      progressIndicatorBuilder: (context, url,
                          downloadProgress) =>
                          LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                      errorWidget: (context, url, error) =>
                          IconButton(
                            onPressed: () {
                              //hier retry
                            },
                            icon: Icon(Icons.error),
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(item['name']),
                    subtitle: Text(item['owner']),
                    trailing: ItemMenus(context).playlistMenuList(item),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
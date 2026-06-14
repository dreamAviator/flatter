import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';
import 'album_screen/album_screen.dart';
import 'itemMenus.dart';

class AlbumGrid extends StatelessWidget {
  const AlbumGrid({super.key,required this.albumListNullable,required this.crossAxisCount,required this.sliver,this.filterNotifier});
  final List<dynamic>? albumListNullable;
  final int crossAxisCount;
  final bool sliver;
  final ValueNotifier<String>? filterNotifier;

  @override
  Widget build(BuildContext context) {
    List<dynamic> albumList = [];
    if (albumListNullable != null && albumListNullable?.isEmpty == false) {
      print(albumListNullable);
      albumList.addAll(albumListNullable!);
    } else {
      if (sliver == true) {
        return SliverToBoxAdapter(
          child: Center(child: Text("No songs")),
        );
      } else {
        return Center(child: Text("No songs"));
      }
    }
    if (sliver == true) {
      if (filterNotifier != null) {
        return ValueListenableBuilder(
          valueListenable: filterNotifier!,
          builder: (context,String filter,child) {
            List<dynamic> filteredAlbumList = new List.from(albumList);
            if (filter.isNotEmpty) {
              filteredAlbumList.removeWhere((item) {
                if (item is Map) {
                  for (var value in item.values) {
                    if (value is String) {
                      if (value.toLowerCase().contains(filter.toLowerCase())) {
                        return false;
                      }
                    }
                  }
                }
                return true;
              });
            }
            if (filteredAlbumList.isEmpty) {
              return (SliverToBoxAdapter(child: Center(child: Text("No albums")),));
            }
            return SliverMasonryGrid.count(
              crossAxisCount: crossAxisCount,
              childCount: filteredAlbumList.length,
              itemBuilder: (context, index) {
                Map albumOne = filteredAlbumList[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}",
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                            errorWidget: (context, url, error) => IconButton(
                              onPressed: () {
                                //hier retry
                              },
                              icon: Icon(Icons.error),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(albumOne['name']),
                          subtitle: Text(albumOne['artist']),
                          trailing: ItemMenus(context).albumMenuList(albumOne),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      } else {
        return SliverMasonryGrid.count(
          crossAxisCount: crossAxisCount,
          childCount: albumList.length,
          itemBuilder: (context, index) {
            Map albumOne = albumList[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}",
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) => IconButton(
                          onPressed: () {
                            //hier retry
                          },
                          icon: Icon(Icons.error),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(albumOne['name']),
                      subtitle: Text(albumOne['artist']),
                      trailing: ItemMenus(context).albumMenuList(albumOne),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      if (filterNotifier != null) {
        return ValueListenableBuilder(
          valueListenable: filterNotifier!,
          builder: (context,String filter,child) {
            List<dynamic> filteredAlbumList = new List.from(albumList);
            if (filter.isNotEmpty) {
              filteredAlbumList.removeWhere((item) {
                if (item is Map) {
                  for (var value in item.values) {
                    if (value is String) {
                      if (value.toLowerCase().contains(filter.toLowerCase())) {
                        return false;
                      }
                    }
                  }
                }
                return true;
              });
            }
            if (filteredAlbumList.isEmpty) {
              return (SliverToBoxAdapter(child: Center(child: Text("No albums")),));
            }
            return MasonryGridView.count(
              crossAxisCount: crossAxisCount,
              itemCount: filteredAlbumList.length,
              itemBuilder: (context, index) {
                Map albumOne = filteredAlbumList[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}",
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                            errorWidget: (context, url, error) => IconButton(
                              onPressed: () {
                                //hier retry
                              },
                              icon: Icon(Icons.error),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(albumOne['name']),
                          subtitle: Text(albumOne['artist']),
                          trailing: ItemMenus(context).albumMenuList(albumOne),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      } else {
        return MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            Map albumOne = albumList[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: albumOne['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${albumOne['coverArt']}",
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) => IconButton(
                          onPressed: () {
                            //hier retry
                          },
                          icon: Icon(Icons.error),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(albumOne['name']),
                      subtitle: Text(albumOne['artist']),
                      trailing: ItemMenus(context).albumMenuList(albumOne),
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


}
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../main.dart';
import 'artist_screen/artist_screen.dart';
import 'itemMenus.dart';//TODO:Item menus hierfür hinzufügen

class ArtistGrid extends StatelessWidget {
  const ArtistGrid({super.key,required this.artistListNullable,required this.crossAxisCount,required this.sliver,this.filterNotifier});
  final List<dynamic>? artistListNullable;
  final int crossAxisCount;
  final bool sliver;
  final ValueNotifier<String>? filterNotifier;

  @override
  Widget build(BuildContext context) {
    List<dynamic> artistList = [];
    if (artistListNullable != null && artistListNullable?.isEmpty == false) {
      print(artistListNullable);
      artistList.addAll(artistListNullable!);
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
            List<dynamic> filteredArtistList = new List.from(artistList);
            if (filter.isNotEmpty) {
              filteredArtistList.removeWhere((item) {
                if (item is Map) {
                  if (item['name'] is String) {
                    if (item['name'].toLowerCase().contains(filter.toLowerCase())) {
                      return false;
                    }
                  }
                }
                return true;
              });
            }
            if (filteredArtistList.isEmpty) {
              return (SliverToBoxAdapter(child: Center(child: Text("No artists")),));
            }
            return SliverMasonryGrid.count(
              crossAxisCount: crossAxisCount,
              childCount: filteredArtistList.length,
              itemBuilder: (context, index) {
                Map item = filteredArtistList[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
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
                        Text(item['name']),
                        Text(item['id']),
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
          childCount: artistList.length,
          itemBuilder: (context, index) {
            Map item = artistList[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
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
                    Text(item['name']),
                    Text(item['id']),
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
            List<dynamic> filteredArtistList = new List.from(artistList);
            if (filter.isNotEmpty) {
              filteredArtistList.removeWhere((item) {
                if (item is Map) {
                  if (item['name'] is String) {
                    if (item['name'].toLowerCase().contains(filter.toLowerCase())) {
                      return false;
                    }
                  }
                }
                return true;
              });
            }
            if (filteredArtistList.isEmpty) {
              return (Center(child: Text("No artists")));
            }
            return MasonryGridView.count(
              crossAxisCount: crossAxisCount,
              itemCount: filteredArtistList.length,
              itemBuilder: (context, index) {
                Map item = filteredArtistList[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
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
                        Text(item['name']),
                        Text(item['id']),
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
          itemCount: artistList.length,
          itemBuilder: (context, index) {
            Map item = artistList[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistScreen(artistID: item['id'])));
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${item['coverArt']}",
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
                    Text(item['name']),
                    Text(item['id']),
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
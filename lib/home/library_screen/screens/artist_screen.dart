
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/library_screen/item_widgets/album_grid.dart';
import 'package:flatter/home/library_screen/item_widgets/per_item/item_menus.dart';
import 'package:flatter/home/search_screen/search_song_screen.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../item_widgets/per_item/favorite_button.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key,required this.artistID});
  final String artistID;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  SubsonicService subsonicService = SubsonicService();

  @override
  Widget build(BuildContext context) {
    ItemMenus itemMenus = ItemMenus(context);
    final Size screenSize = MediaQuery.sizeOf(context);

    Widget buildArtistAppearances(BuildContext context,String name,double screenWidth) {
      return FutureBuilder(
        future: subsonicService.getArtistAppearances(widget.artistID, name),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return AlbumGrid(albumListNullable: asyncSnapshot.data!,crossAxisCount: (screenSize.width / 175).toInt(),sliver: true,);
          } else if (asyncSnapshot.hasError) {
            return SliverToBoxAdapter(child: Text(asyncSnapshot.error.toString()));
          } else {
            return SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25));
          }
        }
      );
    }

    return FutureBuilder(
      future: subsonicService.getArtistDetails(widget.artistID),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(asyncSnapshot.data!['name']),
              actions: [
                IconButton(
                  onPressed: () {
                    String action = settingsControl.loadSetting('artistPlayButtonAction');
                    switch (action) {
                      case "playNow":
                        playerControl.customAction('clearQueue');
                        playerControl.customAction('addByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                        }});
                      case "playNext":
                        playerControl.customAction('addNextByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                        }});
                      case "enqueue":
                        playerControl.customAction('addByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                        }});
                      case "playNowShuffled":
                        playerControl.customAction('clearQueue');
                        playerControl.customAction('addByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                          'shuffled':true,
                        }});
                      case "playNextShuffled":
                        playerControl.customAction('addNextByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                          'shuffled':true,
                        }});
                      case "enqueueShuffled":
                        playerControl.customAction('addByID', {'addByID': {
                          'artistID':asyncSnapshot.data!['id'],
                          'shuffled':true,
                        }});
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                FavoriteButton(songID: null, albumID: null, artistID: widget.artistID),
                itemMenus.artistMenu(asyncSnapshot.data!),
              ],
            ),
            body: CustomScrollView(
              slivers: [//evt einige actions von den actions hier nach oben oder so mal schauen wie du das strukturieren willst
                //hier evt einen text von nem anderen server fetchen idk ob das bei alben geht
                if (settingsControl.settingsMap['landscapeMode'] == false) SliverToBoxAdapter(
                  child: CachedNetworkImage(
                    imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${asyncSnapshot.data!['coverArt']}",
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    errorWidget: (context, url, error) => IconButton(
                      onPressed: () {
                        //hier retry
                      },
                      icon: Icon(Icons.error),
                    ),
                    height: screenSize.width,
                  ),
                ),
                if (settingsControl.settingsMap['landscapeMode'] == false) SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("hier sollen actions hin"),
                      ElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("All songs"),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchSongScreen(query: asyncSnapshot.data!['name'])));
                        },
                      ),
                    ],
                  ),
                ),
                if (settingsControl.settingsMap['landscapeMode'] == true) SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${asyncSnapshot.data!['coverArt']}",
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                        errorWidget: (context, url, error) => IconButton(
                          onPressed: () {
                            //hier retry
                          },
                          icon: Icon(Icons.error),
                        ),
                        width: screenSize.width / 3,
                        height: screenSize.width / 3,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("hier"),
                            Text("sollen"),
                            Text("actions"),
                            Text("hin"),
                            ElevatedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("All songs"),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchSongScreen(query: asyncSnapshot.data!['name'])));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: Text("Albums")),
                AlbumGrid(albumListNullable: asyncSnapshot.data!['album'],crossAxisCount: (screenSize.width / 175).toInt(),sliver: true,),
                const SliverToBoxAdapter(child: Divider()),
                const SliverToBoxAdapter(child: Text("Appears in:")),
                buildArtistAppearances(context, asyncSnapshot.data!['name'], screenSize.width),
              ],
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(child: Text("Error"),),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
            ),
            body: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),),
          );
        }
      }
    );
  }
}

//old build album grid
/*
  Widget buildAlbumGrid(BuildContext context,List<dynamic>? albumsNullable,double screenWidth) {
    //hier halt das gridview, evt aus diesen imagecards
    //idk ob gridview.builder der call ist oder besser gesagt wann das nicht der call ist :shrug:
    List<dynamic> albums = [];
    print(albumsNullable);
    print("thjs was albvumsnullable");
    if (albumsNullable == null || albumsNullable.isEmpty) {
      return Text("No albums");
    }
    for (var value in albumsNullable) {
      albums.add(value);
    }
    List<Widget> widgetList = [];
    for (Map<dynamic,dynamic> album in albums) {
      widgetList.add(
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlbumScreen(albumID: album['id'])));
            },
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: "${subsonicService.getURL(null, null, null)[0]}getCoverArt${subsonicService.getURL(null, null, null)[1]}&id=${album['coverArt']}",
                    progressIndicatorBuilder: (context, url, downloadProgress) => LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                    errorWidget: (context,url,error) => IconButton(
                      onPressed: () {
                        //hier retry
                      },
                      icon: Icon(Icons.error),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(album['name']),
                  subtitle: Text("Song count: ${album['songCount']}"),
                  trailing: ItemMenus(context).albumMenuList(album),
                ),
              ],
            ),
          ),
        )
      );
    }
    return SliverToBoxAdapter(child: MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList));
  }

   */
import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/library_screen/popups/edit_playlist_popup.dart';
import 'package:flatter/home/library_screen/tabs/playlists_tab/playlists_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/item_widgets/playlist_grid.dart';
import 'package:flatter/home/library_screen/filter_widgets/search_string_filter_widget.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class PlaylistsTab extends StatefulWidget {
  const PlaylistsTab({super.key,required this.viewModel});
  final PlaylistsTabViewModel viewModel;

  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  String type = "random";
  bool ascending = true;
  int elementCount = 10;
  int offset = 0;
  List<String> filterSortList = ["random","50","0","ASC"];

  void reverseSort() {
    if (ascending == true) {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"DESC"];
        ascending = false;
      });
    } else {
      setState(() {
        filterSortList = [type,elementCount.toString(),offset.toString(),"ASC"];
        ascending = true;
      });
    }
  }

  /*
  Widget buildListView(List<dynamic> items,BuildContext context,double screenWidth) {
    List<Widget> widgetList = [];
    List<Widget> widgetListTwo = [];
    int index = 0;
    while (index < items.length) {
      Map playlist = items[index];
      if (playlist['owner'] == databaseControl.getCurrentUsername()) {
        widgetList.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlost tapped");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: playlist['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${playlist['coverArt']}",
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
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['songCount'].toString()),
                    trailing: ItemMenus(context).playlistMenuList(playlist),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index = index + 1;
    }
    index = 0;
    while (index < items.length) {
      Map playlist = items[index];
      if (playlist['owner'] != databaseControl.getCurrentUsername()) {
        widgetListTwo.add(
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print("playlist tabbed");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistScreen(playlistID: playlist['id'])));
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: "${subsonicService.getURL(
                          null, null, null)[0]}getCoverArt${subsonicService
                          .getURL(
                          null, null, null)[1]}&id=${playlist['coverArt']}",
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
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['owner']),
                    trailing: ItemMenus(context).playlistMenuList(playlist),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      index = index + 1;
    }
    return Expanded(child: SingleChildScrollView(child: Column(
      children: [
        MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList,),
        Divider(),
        Text("Public"),
        MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetListTwo,),
      ],
    )));
  }
  */

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final ValueNotifier<String> filterNotifier = ValueNotifier('');
    final SubsonicService subsonicService = SubsonicService();
    final UpdateNotifier playlistChangedNotifier = UpdateNotifier();
    return Stack(
      children:[
        IntrinsicSizeBuilder(
          subject: SearchStringFilterWidget(filterNotifier: filterNotifier),
          builder: (context, subjectSize,subject) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  primary: false,
                  floating: true,
                  snap: true,
                  expandedHeight: subjectSize.height,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      bool visible = true;
                      print(constraints.maxHeight);
                      print(subjectSize.height);
                      if (constraints.heightConstraints().maxHeight < subjectSize.height) {
                        visible = false;
                      }
                      return Visibility(visible: visible,child: subject);
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: Text("Own"),),
                ListenableBuilder(
                  listenable: playlistChangedNotifier,
                  builder: (context, child) {
                    return FutureBuilder(
                      future: subsonicService.getPlaylists(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                          return PlaylistGrid(playlistListNullable: asyncSnapshot.data,crossAxisCount: (screenSize.width / 175).toInt(),sliver: true,onlyOwn: true,filterNotifier: filterNotifier,playlistChangedNotifier: playlistChangedNotifier,);
                        } else if (asyncSnapshot.hasError) {
                          return SliverToBoxAdapter(child: Text("Error"),);
                        } else {
                          return SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),);
                        }
                      }
                    );
                  }
                ),
                const SliverToBoxAdapter(child: Text("Shared with you"),),
                ListenableBuilder(
                  listenable: playlistChangedNotifier,
                  builder: (context, child) {
                    return FutureBuilder(
                      future: subsonicService.getPlaylists(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                          return PlaylistGrid(playlistListNullable: asyncSnapshot.data,crossAxisCount: (screenSize.width / 175).toInt(),sliver: true,onlyOwn: false,filterNotifier: filterNotifier,playlistChangedNotifier: playlistChangedNotifier,);
                        } else if (asyncSnapshot.hasError) {
                          return SliverToBoxAdapter(child: Text("Error"),);
                        } else {
                          return SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),);
                        }
                      }
                    );
                  }
                ),
              ],
            );
          }
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                EditPlaylistPopup.showEditPlaylistPopUp(context, true, null, null, null, null, null,playlistChangedNotifier);
              },
            ),
          ),
        ),
      ],
    );
  }
}
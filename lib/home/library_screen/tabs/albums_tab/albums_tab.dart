import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/home/library_screen/item_widgets/album_grid.dart';
import 'package:flatter/home/library_screen/tabs/albums_tab/albums_tab_ViewModel.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class AlbumsTab extends StatefulWidget {
  const AlbumsTab({super.key,required this.viewModel});
  final AlbumsTabViewModel viewModel;

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  String type = settingsControl.loadSetting('albumDropDownFilterSelection');
  int elementCount = 50;
  int offset = 0;
  List<String> filterSortList = ["random","50","0"];
  final SubsonicService subsonicService = SubsonicService();

  /*
  Widget buildListView(List<dynamic> items,BuildContext context,double screenWidth) {
    List<Widget> widgetList = [];
    int index = 0;
    while (index < items.length) {
      Map albumOne = items[index];
      widgetList.add(
        Card(
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
        ),
      );
      index = index + 1;
    }
    return Expanded(child: SingleChildScrollView(child: MasonryGrid(column: (screenWidth / 175).toInt(),children: widgetList,)));
  }
  
   */
  
  Future<List> getAlbums(String type, int size, int offset) async {
    List<dynamic> albumMapList = [];
    if (filterSortList[0] == "favorites") {
      Map<dynamic,dynamic> starred = await subsonicService.getStarred();
      albumMapList = starred['album'];
    } else {
      albumMapList = await subsonicService.getAlbums(type,size,offset);
    }
    return albumMapList;
  }

  @override
  Widget build(BuildContext context) {
    filterSortList = [type,"$elementCount","$offset"];
    final Size screenSize = MediaQuery.sizeOf(context);
    return Expanded(
      child: IntrinsicSizeBuilder(
        subject: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu<String>(
                selectOnly: true,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "favorites", label: "Favorites"),
                  DropdownMenuEntry(value: "random", label: "Random"),
                  DropdownMenuEntry(value: "newest", label: "Newest"),
                  DropdownMenuEntry(value: "highest", label: "Highest"),
                  DropdownMenuEntry(value: "frequent", label: "Frequent"),
                  DropdownMenuEntry(value: "Recent", label: "Recent"),
                  DropdownMenuEntry(value: "alphabeticalByName", label: "Alphabetical by name"),
                  DropdownMenuEntry(value: "alphabeticalByArtist", label: "Alphabetical by artist"),
                  DropdownMenuEntry(value: "byYear", label: "byYear"),
                  DropdownMenuEntry(value: "byGenre", label: "byGenre"),
                ],
                initialSelection: settingsControl.loadSetting('albumDropDownFilterSelection'),
                onSelected: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    type = value;
                    settingsControl.changeSetting('albumDropDownFilterSelection', value);
                  });
                },
              ),
            ),
          ],
        ),
        builder: (context,subjectSize,subject) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                primary: false,
                floating: true,
                snap: true,
                expandedHeight: subjectSize.height,
                flexibleSpace: Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool visible = true;
                      print(constraints.maxHeight);
                      print(subjectSize.height);
                      if (constraints.heightConstraints().maxHeight < subjectSize.height) {
                        visible = false;
                      }
                      return Visibility(visible: visible,child: subject);
                    }
                )),
              ),
              FutureBuilder(
                future: getAlbums(type,elementCount,offset),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                    return AlbumGrid(albumListNullable: asyncSnapshot.data,crossAxisCount: (screenSize.width / 175).toInt(),sliver: true);
                  } else if (asyncSnapshot.hasError) {
                    return SliverToBoxAdapter(child: Text("Error"),);
                  } else {
                    return SliverToBoxAdapter(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),);
                  }
                }
              ),
            ],
          );
        },
      ),
    );
  }
}
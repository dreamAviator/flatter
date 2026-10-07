import 'package:flatter/home/settings_screen/behavior_settings/search_settings/clear_search_setting.dart';
import 'package:flatter/home/settings_screen/behavior_settings/search_settings/song_search_result_count_setting.dart';
import 'package:material_ui/material_ui.dart';

import 'album_search_result_count_setting.dart';
import 'artist_search_result_count_setting.dart';

class SearchSettingsScreen extends StatelessWidget {
  const SearchSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(//hier space zwischen allen items machen
        shrinkWrap: true,
        children: const [
          ListTile(
            title: Text("Clear search"),
            trailing: ClearSearchSetting(),
            subtitle: Text("Clear the search input after leaving the search screen"),
          ),
          Divider(),
          ListTile(
            title: Text("Song search results count"),
            trailing: SongSearchResultCountSetting(),
          ),
          ListTile(
            title: Text("Album search results count"),
            trailing: AlbumSearchResultCountSetting(),
          ),
          ListTile(
            title: Text("Artist search results count"),
            trailing: ArtistSearchResultCountSetting(),
          )
        ],
      ),
    );
  }
}
import 'package:flatter/settings/behaviour_settings/search_settings/clear_search_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

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
        children: [
          ListTile(
            title: Text("Clear search"),
            trailing: ClearSearchSetting(),
            subtitle: Text("Clear the search input after leaving the search screen"),
          ),
          //TODO:search results number setting, mit dem gleichen number picker package auch die anderen settings mit zahlen einrichten :3
        ],
      ),
    );
  }
}
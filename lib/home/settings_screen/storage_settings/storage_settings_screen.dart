import 'package:flatter/home/settings_screen/storage_settings/delete_image_cache_popup.dart';
import 'package:flatter/home/settings_screen/storage_settings/image_cache_stale_period_setting.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';

class StorageSettingsScreen extends StatelessWidget {
  const StorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Settings"),
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
            title: Text("Image Cache Stale Period"),
            subtitle: Text("Controls how long images should be cached until they're deleted and redownloaded. Value in days."),
            trailing: ImageCacheStalePeriodSetting()
          ),
          ListTile(
            title: Text("Delete image cache"),
            subtitle: Text("This will delete all currently cached images. All images will have to be redownloaded. Affects all servers. You can delete the cache for specific images by long tapping one."),//TODO:vielleicht ein menü um alle bilder zu sehen und zu löschen wenn man will
            trailing: DeleteImageCacheSetting(),
          )
        ],
      ),
    );
  }
}
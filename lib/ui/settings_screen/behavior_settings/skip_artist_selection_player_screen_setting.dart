import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class SkipArtistSelectionPlayerScreenSetting extends StatefulWidget {
  const SkipArtistSelectionPlayerScreenSetting({super.key});

  @override
  State<SkipArtistSelectionPlayerScreenSetting> createState() => _SkipArtistSelectionPlayerScreenSettingState();
}

class _SkipArtistSelectionPlayerScreenSettingState extends State<SkipArtistSelectionPlayerScreenSetting> {
  @override
  Widget build(BuildContext context) {
    bool clearSearch = settingsControl.loadSetting('skipArtistSelectionOnPlayerScreen');
    return Switch(
      value: clearSearch,
      onChanged: (bool value) {
        settingsControl.changeSetting('skipArtistSelectionOnPlayerScreen', value);
        setState(() {
          clearSearch = value;
        });
      },
    );
  }

}
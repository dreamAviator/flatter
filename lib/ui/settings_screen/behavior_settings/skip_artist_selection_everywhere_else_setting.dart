import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class SkipArtistSelectionEverywhereElseSetting extends StatefulWidget {
  const SkipArtistSelectionEverywhereElseSetting({super.key});

  @override
  State<SkipArtistSelectionEverywhereElseSetting> createState() => _SkipArtistSelectionEverywhereElseSettingState();
}

class _SkipArtistSelectionEverywhereElseSettingState extends State<SkipArtistSelectionEverywhereElseSetting> {
  @override
  Widget build(BuildContext context) {
    bool clearSearch = settingsControl.loadSetting('skipArtistSelectionEverywhereElse');
    return Switch(
      value: clearSearch,
      onChanged: (bool value) {
        settingsControl.changeSetting('skipArtistSelectionEverywhereElse', value);
        setState(() {
          clearSearch = value;
        });
      },
    );
  }

}
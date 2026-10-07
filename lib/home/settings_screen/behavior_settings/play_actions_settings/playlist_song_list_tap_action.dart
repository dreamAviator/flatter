import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class PlaylistSongListTapActionSetting extends StatefulWidget {
  const PlaylistSongListTapActionSetting({super.key});

  @override
  State<PlaylistSongListTapActionSetting> createState() => _PlaylistSongListTapActionSetting();
}

class _PlaylistSongListTapActionSetting extends State<PlaylistSongListTapActionSetting> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      selectOnly: true,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'playNow',label: "Play now"),
        DropdownMenuEntry(value: 'playNext', label: "Play next"),
        DropdownMenuEntry(value: 'enqueue', label: "Enqueue"),
      ],
      initialSelection: settingsControl.settingsMap['playlistSongListTapAction'],
      onSelected: (value) {
        settingsControl.changeSetting('playlistSongListTapAction', value);
      },
    );
  }
}
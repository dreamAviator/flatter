import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/playlists_tab/playlists_tab_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class PlaylistsTab extends StatelessWidget {
  const PlaylistsTab({super.key,required this.viewModel});
  final PlaylistsTabViewModel viewModel;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is playlists tab"),
    );
  }
}
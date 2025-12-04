import 'package:flatter/home/library_screen/library_tab_bar/songs_tab/songs_tab_viewModel.dart';
import 'package:flutter/cupertino.dart';

class SongsTab extends StatelessWidget {
  const SongsTab({super.key,required this.viewModel});
  final SongsTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is songs tab"),
    );
  }
}
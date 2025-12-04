import 'package:flatter/home/library_screen/library_tab_bar/albums_tab/albums_tab_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key,required this.viewModel});
  final AlbumsTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is albums tab"),
    );
  }
}
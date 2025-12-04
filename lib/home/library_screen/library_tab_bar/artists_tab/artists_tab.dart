import 'package:flatter/home/library_screen/library_tab_bar/artists_tab/artists_tab_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key,required this.viewModel});

  final ArtistsTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is artists tab"),
    );
  }
}
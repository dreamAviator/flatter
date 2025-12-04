import 'package:flatter/home/library_screen/library_screen_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/library_tab_bar.dart';
import 'package:flutter/cupertino.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key,required this.viewModel});
  final LibraryScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LibraryTabBar(),
    );
  }
}
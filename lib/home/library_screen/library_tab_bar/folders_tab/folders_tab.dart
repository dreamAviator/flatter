import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class FoldersTab extends StatelessWidget {
  const FoldersTab({super.key,required this.viewModel});
  final FoldersTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("this is folders tab"),
    );
  }
}
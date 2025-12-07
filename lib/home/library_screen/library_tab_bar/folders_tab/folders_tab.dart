import 'dart:typed_data';

import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab_ViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoldersTab extends StatelessWidget {
  const FoldersTab({super.key,required this.viewModel});
  final FoldersTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: viewModel.leaveFolder, icon: Icon(Icons.arrow_upward)),
          IconButton(onPressed: viewModel.addFolder, icon: Icon(Icons.folder)),//den knopf wegmachen wenn man nicht im start ordner ist
        ],
        title: ListenableBuilder(
          listenable: viewModel,
          builder: (context,_) {
            return Text(viewModel.title);
          },
        )
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context,_) {
          return ListView.builder(
            itemCount: viewModel.toDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: InkWell(
                  onTap: () => viewModel.goIntoFolder(viewModel.toDisplay[index]),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(viewModel.toDisplay[index]),
                        trailing: IconButton(
                          onPressed: () => viewModel.removeFolder(viewModel.toDisplay[index]),
                          icon: Icon(CupertinoIcons.trash_fill),
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          );
        },
      )
    );
  }
}
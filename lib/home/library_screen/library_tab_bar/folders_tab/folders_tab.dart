import 'dart:typed_data';

import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/folders_tab_ViewModel.dart';
import 'package:flatter/home/library_screen/library_tab_bar/folders_tab/three_dot_options/three_dot_options_button.dart';
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
          IconButton(onPressed: viewModel.leaveFolder, icon: Icon(Icons.arrow_upward)),//den knopf wegmachen wenn man im start ordner ist
          IconButton(onPressed: viewModel.addFolder, icon: Icon(Icons.folder)),
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
          return ListView.builder(//eventuell ersetzen durch scrollable positioned list class, für das nach oben scrollen; oder einen scroll controller einbauen, mal genauer informieren
            itemCount: viewModel.toDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: InkWell(
                  onTap: () => viewModel.openEntry(viewModel.toDisplay[index][0]),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(viewModel.toDisplay[index][2]),
                        title: Text(viewModel.toDisplay[index][1]),
                        subtitle: Text(viewModel.toDisplay[index][0]),
                        trailing: SongOptionsButton(viewModel.toDisplay[index][0]),
                        //trailing: IconButton(onPressed: () => viewModel.threePoint(viewModel.toDisplay[index][0]), icon: Icon(Icons.more_vert)),
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
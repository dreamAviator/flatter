import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart';

class DeleteImageCacheSetting extends StatelessWidget {
  const DeleteImageCacheSetting({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> showDeleteCachePopup(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete cache"),
            content: SingleChildScrollView(
              child: Text('''
Delete the image cache?
All images currently cached will have to be redownloaded.
Affects all servers.
          '''),
            ),
            actions: [
              TextButton(
                child: Text("Delete cache"),
                onPressed: () {
                  cacheManager.emptyCache();
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Keep cache"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }

    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showDeleteCachePopup(context);
      },
    );
  }
}
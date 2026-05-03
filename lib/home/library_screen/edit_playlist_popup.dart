import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPlaylistPopup {
  static void showEditPlaylistPopUp(BuildContext context,bool newCreate,String? id,String? name,String? comment,bool? public,List<dynamic>? songIDsToAdd) {
    if (newCreate == false && id == null) {
      return;
    }
    print("builder executed");
    String title = "Create playlist";
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController playlistNameController = TextEditingController();
    TextEditingController playlistCommentController = TextEditingController();
    if (name != null) {
      playlistNameController.text = name;
      title = "Edit $name";
    }
    if (comment != null) {
      playlistCommentController.text = comment;
    }
    public ??= false;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  if (id != null) IconButton(
                    onPressed: () {
                      subsonicService.deletePlaylist(id);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 8,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Playlist Name",
                          border: OutlineInputBorder(),
                        ),
                        controller: playlistNameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Comment",
                          border: OutlineInputBorder(),
                        ),
                        controller: playlistCommentController,
                      ),
                      ListTile(
                        leading: Text("Public"),
                        trailing: Switch(
                          value: public!,
                          onChanged: (bool value) {
                            setState(() {
                              public = value;
                            });
                          },
                        )
                      ),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (newCreate == false) {
                              subsonicService.updatePlaylist(id!, playlistNameController.text, playlistCommentController.text, public!.toString(), null, null);
                            } else {
                              subsonicService.createPlaylist(playlistNameController.text, songIDsToAdd);
                              if (playlistCommentController.text != "") {
                                //hier den kommentar updaten irgendwie, idk warum das nicht im create request geht
                              }
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
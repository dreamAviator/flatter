import 'dart:io';

import 'package:audiotags/audiotags.dart';

class MetadataControl {
  late Tag? tags;

  Future<void> loadFile(String path) async {
    //TODO: ich brauch eine datei oder zumindest den pfad maaaaan
    tags = await AudioTags.read(path);
  }
}
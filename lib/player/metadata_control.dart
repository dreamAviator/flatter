import 'dart:io';

import 'package:audiotags/audiotags.dart';

class MetadataControl {
  late Tag? tags;

  Future<void> loadFile(String path) async {
    tags = await AudioTags.read(path);
    print("hello");
    print(tags?.title);
    print(tags?.trackArtist);
    print(tags?.album);
    print("done lol");
  }
}
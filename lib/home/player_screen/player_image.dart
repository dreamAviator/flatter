import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flatter/home/item_widgets/subsonic_image.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({super.key,required this.sidelength});
  final double sidelength;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: playerControl.mediaItem,
      builder: (context, snapshot) {
        final coverID = snapshot.data?.extras?['coverArt'];
        if (coverID == null) {
          return Image.asset("lib/assets/images/empty_player.png",width: sidelength,);
        } else {
          return SubsonicImage(coverArtID: coverID,height: sidelength,width: sidelength,type: "song",);
        }
      },
    );
  }
}
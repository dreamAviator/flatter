import 'package:audio_service/audio_service.dart';
import 'package:flatter/main.dart';
import 'package:material_ui/material_ui.dart';

class LoopButton extends StatefulWidget {
  const LoopButton({super.key});

  @override
  State<LoopButton> createState() => _LoopButtonState();
}

class _LoopButtonState extends State<LoopButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: playerControl.playbackState.map((data) => data.repeatMode).distinct(),
      builder: (context,asyncSnapshot) {
        print(asyncSnapshot.data);
        print("this was data");
        print(asyncSnapshot.hasData);
        print(asyncSnapshot.connectionState);
        if (asyncSnapshot.hasData && asyncSnapshot.connectionState != ConnectionState.waiting) {
          if (asyncSnapshot.data == null) {
            return IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.pending_outlined),//hm, mal schauen. auf einigen screens brauche ich outlined auf anderen nicht glaube ich
            );
          } else {//this is an extra if thingy because of old code, and idrc rn enough to change it
            if (asyncSnapshot.data == AudioServiceRepeatMode.none) {
              return IconButton(
                onPressed: () {
                  playerControl.setRepeatMode(AudioServiceRepeatMode.all);
                },
                icon: const Icon(Icons.start_outlined),//hier halt single und ganze queue
              );
            } else if (asyncSnapshot.data == AudioServiceRepeatMode.all) {
              return IconButton(
                onPressed: () {
                  playerControl.setRepeatMode(AudioServiceRepeatMode.one);
                },
                icon: const Icon(Icons.repeat_outlined),//hier halt single und ganze queue
              );
            } else if (asyncSnapshot.data == AudioServiceRepeatMode.one) {
              return IconButton(
                onPressed: () {
                  playerControl.setRepeatMode(AudioServiceRepeatMode.none);
                },
                icon: const Icon(Icons.repeat_one_outlined),//hier halt single und ganze queue
              );
            }
          }
        }
        return IconButton(
          onPressed: () {

          },
          icon: Icon(Icons.pending_outlined),//hm, mal schauen. auf einigen screens brauche ich outlined auf anderen nicht glaube ich
        );
      },
    );
  }
}
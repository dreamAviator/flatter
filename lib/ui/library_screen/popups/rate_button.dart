import 'package:flatter/Services/subsonic_service.dart';
import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';

class RateButton extends StatelessWidget {
  const RateButton({super.key,required this.id,required this.initialRating,required this.name,this.updateNotifier,this.subsonicService,this.isCurrentSong});
  final String? id;
  final int initialRating;
  final String name;
  final UpdateNotifier? updateNotifier;
  final SubsonicService? subsonicService;
  final bool? isCurrentSong;

  static void showRatePopup(BuildContext context, String id,int rating, String name,[UpdateNotifier? updateNotifier,SubsonicService? subsonicService,bool? isCurrentSong]) {
    subsonicService ??= SubsonicService();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,setState) {
            void setRating(int newRating) {
              subsonicService!.rate(id, newRating);
              if (isCurrentSong == true) {
                playerControl.mediaItem.add(playerControl.mediaItem.value?.copyWith(extras: {
                  ...?playerControl.mediaItem.value?.extras,
                  'userRating':newRating,
                }));
              }
              updateNotifier?.notify();
              setState(() {
                rating = newRating;
              });
              Navigator.of(context).pop();
            }

            return AlertDialog(
              title: Center(child: Text("Rate $name")),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [//i know there is a lot of duplicate not necessary stuff here, but idrc rn
                  if (rating >= 1) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 1) {
                        setRating(0);
                      } else {
                        setRating(1);
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 1) {
                        setRating(0);
                      } else {
                        setRating(1);
                      }
                    },
                  ),
                  if (rating >= 2) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 2) {
                        setRating(0);
                      } else {
                        setRating(2);
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 2) {
                        setRating(0);
                      } else {
                        setRating(2);
                      }
                    },
                  ),
                  if (rating >= 3) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 3) {
                        setRating(0);
                      } else {
                        setRating(3);
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 3) {
                        setRating(0);
                      } else {
                        setRating(3);
                      }
                    },
                  ),
                  if (rating >= 4) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 4) {
                        setRating(0);
                      } else {
                        setRating(4);
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 4) {
                        setRating(0);
                      } else {
                        setRating(4);
                      }
                    },
                  ),
                  if (rating >= 5) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 5) {
                        setRating(0);
                      } else {
                        setRating(5);
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 5) {
                        setRating(0);
                      } else {
                        setRating(5);
                      }
                    },
                  ),

                ],

              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                )
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialRating == 0 || id == null) {
      return IconButton(
        icon: Icon(Icons.thumbs_up_down_outlined),
        onPressed: () {
          if (id != null) {
            showRatePopup(context, id!, initialRating, name,updateNotifier,subsonicService,isCurrentSong);
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.thumbs_up_down),
        onPressed: () {
          showRatePopup(context, id!, initialRating, name,updateNotifier,subsonicService,isCurrentSong);
        },
      );
    }
  }

}
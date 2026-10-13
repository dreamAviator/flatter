import 'package:material_ui/material_ui.dart';

class RatePopup {
  static void showRatePopup(BuildContext context, String id,int rating) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,setState) {
            return AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (rating >= 1) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {

                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {

                    },
                  ),
                  if (rating >= 2) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {

                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {

                    },
                  ),
                  if (rating >= 3) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {

                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {

                    },
                  ),
                  if (rating >= 4) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {

                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {

                    },
                  ),
                  if (rating >= 5) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {

                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {

                    },
                  ),

                ],
              )
            );
          },
        );
      }
    );
  }
}
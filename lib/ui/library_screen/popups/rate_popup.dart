import 'package:flatter/Services/subsonic_service.dart';
import 'package:material_ui/material_ui.dart';

class RatePopup {
  static void showRatePopup(BuildContext context, String id,int rating) {
    SubsonicService subsonicService = SubsonicService();
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
                      if (rating == 1) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 1);
                        setState(() {
                          rating = 1;
                        });
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 1) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 1);
                        setState(() {
                          rating = 1;
                        });
                      }
                    },
                  ),
                  if (rating >= 2) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 2) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 2);
                        setState(() {
                          rating = 2;
                        });
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 2) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 2);
                        setState(() {
                          rating = 2;
                        });
                      }
                    },
                  ),
                  if (rating >= 3) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 3) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 3);
                        setState(() {
                          rating = 3;
                        });
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 3) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 3);
                        setState(() {
                          rating = 3;
                        });
                      }
                    },
                  ),
                  if (rating >= 4) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 4) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 4);
                        setState(() {
                          rating = 4;
                        });
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 4) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 4);
                        setState(() {
                          rating = 4;
                        });
                      }
                    },
                  ),
                  if (rating >= 5) IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      if (rating == 5) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 5);
                        setState(() {
                          rating = 5;
                        });
                      }
                    },
                  ) else IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      if (rating == 5) {
                        subsonicService.rate(id, 0);
                        setState(() {
                          rating = 0;
                        });
                      } else {
                        subsonicService.rate(id, 5);
                        setState(() {
                          rating = 5;
                        });
                      }
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
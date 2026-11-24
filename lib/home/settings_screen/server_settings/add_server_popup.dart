import 'package:flatter/main.dart';
import 'package:flatter/useful_scripts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';



class AddServerPopup {
  static void showAddServerPopUp(BuildContext context,String? serverName,String? serverURL,String? serverUsername,String? serverPassword,int? id,UpdateNotifier serverListUpdateNotifier) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        TextEditingController serverNameController = TextEditingController();
        TextEditingController serverURLcontroller = TextEditingController();
        TextEditingController serverUsernameController = TextEditingController();
        TextEditingController serverPasswordController = TextEditingController();
        String title = "Add Server";
        if (serverName != null && serverURL != null && serverUsername != null && serverPassword!= null && id != null) {
          title = "Edit $serverName";
          serverNameController.text = serverName;
          serverURLcontroller.text = serverURL;
          serverUsernameController.text = serverUsername;
          serverPasswordController.text = serverPassword;
        }
        UpdateNotifier updateNotifier = UpdateNotifier();
        Map currentStatus = {'status':'start'};

        void invalidateStatus() {
          currentStatus['status'] = "edited";
          updateNotifier.notify();
        }

        return AlertDialog(
          constraints: BoxConstraints(maxWidth: 560),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (id != null) IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  databaseControl.deleteServer(id);
                  serverListUpdateNotifier.notify();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text("Use demo"),
              onPressed: () {
                serverPasswordController.value = TextEditingValue(text: "demo");
                serverUsernameController.value = TextEditingValue(text: "demo");
                serverURLcontroller.value = TextEditingValue(text: "demo.navidrome.org");
                serverNameController.value = TextEditingValue(text: "demo");
              },
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: ElevatedButton(
                child: ListenableBuilder(
                  listenable: updateNotifier,
                  builder: (context, child) {
                    return FutureBuilder(
                      future: subsonicService.authenticate(serverURLcontroller.text, serverUsernameController.text, serverPasswordController.text),
                      builder: (context, asyncSnapshot) {
                        if (currentStatus['status'] == "start" || currentStatus['status'] == "edited") {
                          return Icon(Icons.check);
                        } else if (asyncSnapshot.hasData && asyncSnapshot.connectionState == ConnectionState.done) {
                          currentStatus = asyncSnapshot.data!;
                          if (asyncSnapshot.data?['status'] == "ok") {
                            return IntrinsicWidth(
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text("Save"),
                                  Icon(Icons.save_outlined),
                                ],
                              ),
                            );
                          } else if (asyncSnapshot.data?['status'] == "not subsonic") {
                            return IntrinsicWidth(
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text("Server is not subsonic"),
                                  Icon(Icons.check),
                                ],
                              ),
                            );
                          } else if (asyncSnapshot.data?['status'] == "failed") {
                            return IntrinsicWidth(
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text(asyncSnapshot.data?['error']['message']),
                                  Icon(Icons.check),
                                ],
                              ),
                            );
                          } else {
                            return IntrinsicWidth(
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text("Something went wrong"),
                                  Icon(Icons.save_outlined),
                                ],
                              ),
                            );
                          }
                      } else if (asyncSnapshot.hasError) {
                          currentStatus['status'] = "error";
                          return IntrinsicWidth(
                            child: Row(
                              spacing: 8,
                              children: [
                                Text("Unknown error"),
                                Icon(Icons.error_outline),
                              ],
                            ),
                          );
                        } else {
                          return LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 25);
                        }
                      }
                    );
                  }
                ),
                onPressed: () {
                  if (formKey.currentState != null) {
                    if (formKey.currentState!.validate()) {
                      if (currentStatus['status'] == "ok") {
                        if (id != null) {
                          databaseControl.deleteServer(id);
                        }
                        databaseControl.addServer(serverNameController.text, serverURLcontroller.text, serverUsernameController.text, serverPasswordController.text);//TODO:wenn man einen server edited (oder immer, idk, conditions überlegen) den server automatisch selecten
                        Navigator.of(context).pop();
                        serverListUpdateNotifier.notify();
                        return;
                      }
                      currentStatus['status'] = "checking";
                      updateNotifier.notify();
                    }
                  }
                },
              ),
            )
          ],
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 8,
                  children: [
                    TextFormField(
                      controller: serverNameController,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: serverURLcontroller,
                      decoration: const InputDecoration(
                        hintText: "URL",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a URL";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String value) {
                        invalidateStatus();
                      },
                    ),
                    TextFormField(
                      controller: serverUsernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Username";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String value) {
                        invalidateStatus();
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      controller: serverPasswordController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Password";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String value) {
                        invalidateStatus();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
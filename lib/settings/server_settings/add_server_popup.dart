import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Riverpod/riverpod_manager.dart';



class AddServerPopup {
  static void showAddServerPopUp(BuildContext context,String? serverName,String? serverURL,String? serverUsername,String? serverPassword,int? id) {
    final riverpodManager = RiverpodManager();
    String title = "Add Server";
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController serverNameController = TextEditingController();
    TextEditingController serverURLcontroller = TextEditingController();
    TextEditingController serverUsernameController = TextEditingController();
    TextEditingController serverPasswordController = TextEditingController();
    if (serverName != null && serverURL != null && serverUsername != null && serverPassword!= null && id != null) {
      title = "Edit $serverName";
      serverNameController.text = serverName;
      serverURLcontroller.text = serverURL;
      serverUsernameController.text = serverUsername;
      serverPasswordController.text = serverPassword;
    }
    List<String> authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
    void invalideStatus (WidgetRef ref) {
      authentificationInfos = ["","",""];
      ref.invalidate(riverpodManager.authenticateProvider);
    }
    Widget buildResultButtonColumn(context,WidgetRef ref,Map<dynamic,dynamic> responseMap) {
      if (responseMap['status'] == "ok") {
        return Column(
          spacing: 8,
          children: [
            Text("Connection successful"),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.invalidate(riverpodManager.authenticateProvider);
                  if (id != null) {
                    databaseControl.deleteServer(id);
                  }
                  databaseControl.addServer(serverNameController.text, serverURLcontroller.text, serverUsernameController.text,serverPasswordController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
            )
          ],
        );
      } else if (responseMap['status'] == "not subsonic") {
        return Column(
          spacing: 8,
          children: [
            Text("URL does not point to Subsonic or OpenSubsonic compatible server"),
            ElevatedButton(
              onPressed: () {
                authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
                if (_formKey.currentState!.validate()) {
                  ref.invalidate(riverpodManager.authenticateProvider);
                }
              },
              child: Text("Test connection"),
            )
          ],
        );
      } else if (responseMap['status'] == "failed") {
        return Column(
          spacing: 8,
          children: [
            Text(responseMap['error']['message']),
            ElevatedButton(
              onPressed: () {
                authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
                if (_formKey.currentState!.validate()) {
                  ref.invalidate(riverpodManager.authenticateProvider);
                }
              },
              child: Text("Test connection"),
            )
          ],
        );
      } else if (responseMap['status'] == "didn't even try") {
        return Column(
          spacing: 8,
          children: [
            Text(""),
            ElevatedButton(
              onPressed: () {
                authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
                if (_formKey.currentState!.validate()) {
                  ref.invalidate(riverpodManager.authenticateProvider);
                }
              },
              child: Text("Test connection"),
            )
          ],
        );
      } else {
        return Column(
          spacing: 8,
          children: [
            Text('Something went wrong'),
            ElevatedButton(
              onPressed: () {
                authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
                if (_formKey.currentState!.validate()) {
                  ref.invalidate(riverpodManager.authenticateProvider);
                }
              },
              child: Text("Test connection"),
            )
          ],
        );
      }
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(//TODO:wenn etwas richtig läuft und man dan etwas ändert, dann sollte es invalidatet werden
              title: Text(title),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final serverValidStatus = ref.watch(riverpodManager.authenticateProvider(authentificationInfos));
                      return Column(
                        spacing: 8,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Server Name",
                              border: OutlineInputBorder(),
                            ),
                            controller: serverNameController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a Name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Server URL",
                              border: OutlineInputBorder(),
                            ),
                            controller: serverURLcontroller,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a URL";
                              }
                              return null;
                            },
                            onTapOutside: (value) {
                              invalideStatus(ref);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Username",
                              border: OutlineInputBorder(),
                            ),
                            controller: serverUsernameController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a Username";
                              }
                              return null;
                            },
                            onTapOutside: (value) {
                              invalideStatus(ref);
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
                              }
                              return null;
                            },
                            onTapOutside: (value) {
                              invalideStatus(ref);
                            },
                          ),
                          Center(
                            child: switch (serverValidStatus) {
                              AsyncValue(:final value?) => buildResultButtonColumn(context,ref,value),
                              AsyncValue(error: != null) => const Text("Error"),
                              AsyncValue() => Column(
                                children: [
                                  LoadingAnimationWidget.fourRotatingDots(color: Colors.purple, size: 25),
                                  ElevatedButton(
                                    onPressed: null,
                                    child: Text("Test connection"),
                                  )
                                ],
                              ),
                            },
                          )
                        ],
                      );
                    },
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
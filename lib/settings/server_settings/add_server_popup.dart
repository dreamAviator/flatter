import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatter/Services/subsonic_service.dart';



class AddServerPopup {
  static void showAddServerPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState) {
            final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
            late String serverName;
            TextEditingController serverURLcontroller = TextEditingController();
            TextEditingController serverUsernameController = TextEditingController();
            TextEditingController serverPasswordController = TextEditingController();
            List<String> authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
            return AlertDialog(
              title: const Text("Add Server"),
              //TODO:overflow fixen
              content: Form(
                key: _formKey,
                child: Column(
                  spacing: 8,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Server Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Name";
                        }
                        serverName = value;
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
                    ),TextFormField(
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
                    ),
                    Center(
                      child: Consumer(
                        builder: (context,ref,child) {
                          final serverValidStatus = ref.watch(riverpodManager.authenticateProvider(authentificationInfos));
                          return Row(
                            children: [
                              switch (serverValidStatus) {
                                AsyncValue(:final value?) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (value[0] != "")
                                      Text(value[0])
                                    ,
                                    ElevatedButton(
                                      onPressed: () {
                                        print(value);
                                        if (_formKey.currentState!.validate()) {
                                          authentificationInfos = [serverURLcontroller.text,serverUsernameController.text,serverPasswordController.text];
                                          if (value[1] == "Save") {
                                            databaseControl.addServer(serverName, serverURLcontroller.text, serverUsernameController.text,serverPasswordController.text);
                                            ref.invalidate(riverpodManager.serverListProvider);
                                            Navigator.of(context).pop();
                                          } if (value[1] == "Test connection") {
                                            ref.invalidate(riverpodManager.authenticateProvider);
                                          } else {
                                            ref.invalidate(riverpodManager.authenticateProvider);
                                          }
                                          //process data
                                          //also einmal connection testen, dann aus dem speichern test save machen
                                          subsonicService.authenticate(serverURLcontroller.text, serverUsernameController.text, serverPasswordController.text);//gibt den status der authentifizierung
                                        }
                                      },
                                      child: Text(value[1]),
                                    ),
                                  ],
                                ),
                                AsyncValue(error: != null) => const Text("Error"),
                                AsyncValue() => const CircularProgressIndicator(),
                              }
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}
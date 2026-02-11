import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            late String serverURL;
            late String serverUsername;
            late String serverPassword;
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a URL";
                        }
                        serverURL = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Username";
                        }
                        serverUsername = value;
                        return null;
                      },
                    ),TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Password";
                        }
                        serverPassword = value;
                        return null;
                      },
                    ),
                    Center(
                      child: Consumer(
                        builder: (context,ref,child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //process data
                                //also einmal connection testen, dann aus dem speichern test save machen
                                subsonicService.authenticate(serverURL, serverUsername, serverPassword);//gibt den status der authentifizierung
                                databaseControl.addServer(serverName, serverURL, serverUsername,serverPassword);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Save"),
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
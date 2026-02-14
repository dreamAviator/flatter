import 'package:flatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final serverWidgetList = ref.watch(riverpodManager.serverListProvider);
        return Center(
          child: Row(
            children: [
              switch (serverWidgetList) {
                AsyncValue(:final value?) => Expanded(
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: serverWidgetList.requireValue,
                  ),
                ),
                AsyncValue(error: != null) => const Text("Error"),
                AsyncValue() => const CircularProgressIndicator(),
              }
            ],
          ),
        );
      },
    );
  }
}
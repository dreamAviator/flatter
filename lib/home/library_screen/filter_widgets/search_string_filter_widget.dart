import 'package:flutter/material.dart';

class SearchStringFilterWidget extends StatelessWidget {
  const SearchStringFilterWidget({super.key,required this.filterNotifier});
  final ValueNotifier<String> filterNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Filter"
        ),
        onChanged: (String value) {
          filterNotifier.value = value;
        },
      ),
    );
  }
}
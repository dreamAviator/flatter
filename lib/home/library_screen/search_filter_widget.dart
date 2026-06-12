import 'package:flutter/material.dart';

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({super.key,required this.filterNotifier});
  final ValueNotifier<String> filterNotifier;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String value) {
        filterNotifier.value = value;
      },
    );
  }
}
import 'package:flatter/settings/settings_list/settings_list_ViewModel.dart';
import 'package:flutter/cupertino.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key,required this.viewModel});
  final SettingsListViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context,_) {
        return ListView.builder(

        )
      },
    )
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text("About flatter"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

       */
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("flatter"),
              background: Image.asset("lib/assets/icon/app_icon.png"),
            ),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              ListTile(
                leading: ImageIcon(AssetImage("lib/assets/icon/github_icon.png")),
                title: Text("Flatter on GitHub"),
                trailing: Icon(Icons.link),
                onTap: () {
                  launchUrl(Uri.https("github.com","/dreamAviator/flatter"));
                },
              ),
              ListTile(
                leading: Icon(Icons.article),
                title: Text("View licenses"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  showLicensePage(context: context);
                },
              ),
            ]),
          ),
        ]
      ),
    );
  }
}
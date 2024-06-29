
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Images.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UpgradeAccountScreen extends StatelessWidget {
  const UpgradeAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CSCommonAppBar(context, title: "Upgrade to $AppName Plus"),

      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Image.asset(CScloudLogo, height: 150, width: 150),
                Text("Get with FireCloud Plus", style: boldTextStyle()).paddingOnly(top: 10, bottom: 10),
                buildListTileForUpgradeAccount("Works on Windows, macOS, iOS, and Android™"),
                buildListTileForUpgradeAccount("Unlimited Storage"),
                buildListTileForUpgradeAccount("High speed access to your data"),
                buildListTileForUpgradeAccount("Ad-free Experience"),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  color: CSecondColor,
                  child: Text("Upgrade Now", style: boldTextStyle(color: Colors.white, size: 18)),
                ).paddingTop(10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTileForUpgradeAccount(String title) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      leading: const Icon(Icons.cloud_done, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 15)),
    );
  }
}
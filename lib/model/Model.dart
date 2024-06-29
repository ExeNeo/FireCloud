

import 'package:cloud/component/CommonFileComponents.dart';
import 'package:cloud/screens/CStarredScreen.dart';
import 'package:cloud/screens/CUpgrade.dart';
import '../../../screens/CDashboardScreen.dart';
import '../../../screens/CSettingScreen.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/Images.dart';
import 'package:flutter/material.dart';

class DataModel {
  String fileUrl;String? fileName;int? size;String? size1;String? time;String? mimeType;String? url;String? downloadUrl;
  bool? isFileSelect;bool isStared;bool isFolder;bool isShared;

  DataModel({this.downloadUrl,this.url,this.fileUrl = CSDefaultImg, this.fileName, this.isFileSelect = false,  this.isShared = false, this.isStared = false, this.isFolder = false,this.mimeType,this.size,this.size1,this.time});
}

List<DataModel> getcloudData() {
  List<DataModel> dataModel = [];

  return dataModel;
}
List<DataModel> getfullData() {
  List<DataModel> dataModel = [];

  return dataModel;
}
class DrawerModel {
  String? title;
  IconData? icon;
  Widget? goto;
  bool isSelected;

  DrawerModel({this.title, this.icon, this.goto, this.isSelected = false});
}

List<DrawerModel> getCSDrawer() {
  List<DrawerModel> drawerModel = [];
  drawerModel.add(DrawerModel(title: "Home", icon: Icons.home, goto: const DashboardScreen()));
  drawerModel.add(DrawerModel(title: "Starred", icon: Icons.star, goto:  const StarredScreen()));
  drawerModel.add(DrawerModel(title: "Files", icon: Icons.folder, goto: const CommonFileComponents(appBarTitle: AppName)));
   drawerModel.add(DrawerModel(title: "Setting", icon: Icons.settings, goto: const SettingScreen()));
   drawerModel.add(DrawerModel(title: "Upgrade", icon: Icons.cloud_upload, goto: const UpgradeAccountScreen()));

  return drawerModel;
}


import 'package:cloud/component/DisplayDataInListViewComponents.dart';
import 'package:cloud/main.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RecentScreen extends StatefulWidget {
  static String tag = '/RecentScreen';

  const RecentScreen({super.key});

  @override
  RecentScreenState createState() => RecentScreenState();
}

class RecentScreenState extends State<RecentScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: getcloudList.isNotEmpty
            ? DisplayDataInListViewComponents(
                listOfData: getcloudList,
                isSelect: false,
                isSelectAll: false,
                selectedItem: 0,
                isCopyOrMove: false,
                onListChanged: () {
                  setState(() {});
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cable_outlined,size: 100,color: CSecondColor,),
                    Text("Recnts will be here", style: boldTextStyle(size: 20)).paddingOnly(top: 20, bottom: 10),
                    Wrap(
                      children: [
                        const Text(
                          "After you use an folder, it'll show up here, so it's easier to get to",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ).paddingSymmetric(vertical: 10, horizontal: 50),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

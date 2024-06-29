import 'package:cloud/component/DisplayDataInListViewComponents.dart';
import 'package:cloud/component/Loading.dart';
import 'package:cloud/main.dart';
import 'package:cloud/model/Model.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class StarredHomeScreen extends StatefulWidget {
  static String tag = '/StarredHomeScreen';
   const StarredHomeScreen({super.key});

  @override
  StarredHomeScreenState createState() => StarredHomeScreenState();
}

class StarredHomeScreenState extends State<StarredHomeScreen> {
    bool isLoading=true;
  List<DataModel> onlyStarredData() {
    List<DataModel> starredData = [];
    for (var element in getfullList) {
      if (element.isStared) {
        starredData.add(element);
      }
    }

    return starredData;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading=true;

    await getFirstFull('${FirebaseAuth.instance.currentUser!.uid}/uploads');
setState((){ isLoading=false;});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            
      body: Container(
        child: isLoading?const Loading(): DisplayDataInListViewComponents(
          listOfData: onlyStarredData(),
          isSelect: false,
          isSelectAll: false,
          selectedItem: 0,
          isCopyOrMove: false,
          onListChanged: () {
            setState(() {});
          },
        ).visible(
          onlyStarredData().isNotEmpty,
          defaultWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 100,color: CSecondColor,),
              Text("Soon the stars will be here", style: boldTextStyle(size: 20)).paddingOnly(top: 20, bottom: 10),
              const Text(
                "After you star an item, it'll show up here, so it's easier to get to",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ).paddingSymmetric(vertical: 10, horizontal: 50),
            ],
          ),
        ),
      ),
    );
  }
}

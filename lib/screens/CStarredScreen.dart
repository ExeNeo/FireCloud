import 'package:cloud/component/DisplayDataInListViewComponents.dart';
import 'package:cloud/component/Loading.dart';
import 'package:cloud/main.dart';
import 'package:cloud/model/Model.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class StarredScreen extends StatefulWidget {
  static String tag = '/StarredScreen';
  
   const StarredScreen({super.key,});

  @override
  StarredScreenState createState() => StarredScreenState();
}

class StarredScreenState extends State<StarredScreen> {
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

    await getFirstFull(FirebaseAuth.instance.currentUser!.uid+'/uploads');
setState((){ isLoading=false;});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body:NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  finish(context);
                },
              ),
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(title: Text("Your FireCloud Stars", style: boldTextStyle())),
            ),
          ];
        },
      body: Container(
        child: isLoading?Loading(): DisplayDataInListViewComponents(
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
    ));
  }
}

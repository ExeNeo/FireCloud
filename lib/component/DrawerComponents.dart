import 'dart:core';
import 'package:cloud/auth/auth_service.dart';
import 'package:cloud/screens/CStartingScreen.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud/main.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DrawerComponents extends StatefulWidget {
  static String tag = '/DrawerComponents';
  
  const DrawerComponents({super.key});

  @override
  DrawerComponentsState createState() => DrawerComponentsState();
}

class DrawerComponentsState extends State<DrawerComponents> {
  int currentIndex = 0;

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
  var email=FirebaseAuth.instance.currentUser!.email!;
  var photo=FirebaseAuth.instance.currentUser!.photoURL;
  var name=FirebaseAuth.instance.currentUser!.displayName ?? 'no name';

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: CSecondColor,
              ),
              margin: const EdgeInsets.all(0),
              // just a frictional character name for the user
              accountName: Text(name, style: boldTextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photo??'',
                scale: 0.2),
              ),
              // just a frictional character email for the user
              
              accountEmail:  Text(email),
            ),
            
            10.height,
            ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: getCSDrawerList.length,
              itemBuilder: (context, index) {
                return Container(
                  color: getCSDrawerList[index].isSelected ? Colors.blueGrey.withOpacity(0.3) : transparentColor,
                  child: createBasicListTile(
                    text: getCSDrawerList[index].title!,
                    icon: getCSDrawerList[index].icon,
                    onTap: () {
                      
                        currentIndex = index;
                        if (getCSDrawerList[index].title != "Setting" ) {
                          for (var element in getCSDrawerList) {
                              element.isSelected = false;
                            }
                        }
                        getCSDrawerList[index].isSelected = true;
                        getCSDrawerList.elementAt(getCSDrawerList.length - 1).isSelected = false;
                        getCSDrawerList.elementAt(getCSDrawerList.length - 2).isSelected = false;              
                        finish(context);
                        getCSDrawerList[index].goto.launch(context);
                      
                    },
                  ).paddingSymmetric(horizontal: 16),
                );
              },
            ),
              buildDivider(isFull: true),
                         buildListTileForSetting(
                title: "Sign out of this cloud",
                color: Colors.red.shade800,
                onTap: () async {
                  bool isSignOut = await (buildCommonDialog(
                    context,
                    posBtn: "Sign out",
                    content: "Are you sure you want to sign out from your $AppName account ?",
                  ));
                  if (isSignOut) {
                    signOut();
                    finish(context);
                    const StartingScreen().launch(context);
                    
                  }
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
      signOut(){
    AuthService().fireSignout();
  }

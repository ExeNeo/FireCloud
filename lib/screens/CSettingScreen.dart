import 'package:cloud/auth/auth_service.dart';
import 'package:cloud/screens/CEditMail.dart';
import 'package:cloud/screens/CResetPassword.dart';
import 'CStartingScreen.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:nb_utils/nb_utils.dart';
class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  var photo=FirebaseAuth.instance.currentUser!.photoURL;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  refreshHere(){
    setState((){
  photo=FirebaseAuth.instance.currentUser!.photoURL;

    });
  }


  @override
  Widget build(BuildContext context) {
      var email=FirebaseAuth.instance.currentUser!.email!;
  var name=FirebaseAuth.instance.currentUser!.displayName ?? 'no name';
      signOut(){
    AuthService().fireSignout();
  }
    return Scaffold(
      body: NestedScrollView(
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
              flexibleSpace: FlexibleSpaceBar(title: Text("$AppName settings", style: boldTextStyle())),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Account", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                  buildDivider(),
                  ListTile(

                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    title: Text(name, style: boldTextStyle()),
                    subtitle: Text(email),
                  
                    leading: CircleAvatar(
                      
                    radius: 50,
                    
                backgroundImage: NetworkImage(photo??'',
                scale: 0.2),),

                  ),
                  
                ],
              ).paddingOnly(top: 15),
              buildDivider(isFull: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Details", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                  buildDivider(),
                  buildListTileForSetting(title: "Email", subTitle: FirebaseAuth.instance.currentUser!.email!, trailing: const Icon(Icons.email)),
                  buildDivider(),
                  buildListTileForSetting(
                    title: "Edit Your Email",

                      trailing: const Icon(Icons.edit),
                      onTap: (){
                        const EditEmail().launch(context);
                      },),
                  buildDivider(),
                      
                  buildListTileForSetting(
                    title: "Reset Your Password",

                      trailing: const Icon(Icons.refresh_rounded),
                      onTap: (){
                        const ResetPasswordScreen().launch(context);
                      },),
                      buildDivider(),
                  buildListTileForSetting(
                    title: "Change profile picture",

                      trailing: const Icon(Icons.image),
                      onTap: (){
                        uploadProfile(context,refreshHere);
                      },),
                      
                  
                ],
              ).paddingOnly(top: 15),

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
              buildDivider(isFull: true),
            ],
          ),
        ),
      ),
    );

  }
}

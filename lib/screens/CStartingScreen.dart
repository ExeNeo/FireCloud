
import 'package:cloud/screens/CSignInScreen.dart';
import 'package:cloud/screens/CSignUpScreen.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/DownloadAndUpload.dart';
import 'package:cloud/utils/Images.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class StartingScreen extends StatefulWidget {
  static String tag = '/StartingScreen';

  const StartingScreen({super.key});

  @override
  StartingScreenState createState() => StartingScreenState();
}

class StartingScreenState extends State<StartingScreen> {



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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome To FireCloud', style: boldTextStyle(size: 20)),
              50.height,
              Image.asset(CScloudLogo, height: 200, width: 200),
              50.height,
              devSignInWidget().onTap(() {
                handleDownloadApp();
              }),
              15.height,
              authButtonWidget("Sign Up").onTap(() {
                const SignUpScreen().launch(context);
              }),
              20.height,
              RichText(
                text: const TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(text: " Sign In", style: TextStyle(color: CSecondColor)),
                  ],
                ),
              ).onTap(
                () {
                  const SignInScreen().launch(context);
                },
              ),
            ],
          ).paddingAll(16.0),
        ),
      ),
    );
  }
}

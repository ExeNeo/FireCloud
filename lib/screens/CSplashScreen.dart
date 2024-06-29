import 'package:cloud/screens/CDashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../screens/CStartingScreen.dart';
import 'package:cloud/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var auth=FirebaseAuth.instance;
  var isLoged=false;
  checkIfLogin()async{
    auth.authStateChanges().listen((User? user){
      if (user!=null&& mounted) {
        setState((){
          isLoged=true;
        });

      }
    });
  }


  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await checkIfLogin();
    checkFirstSeen();
  }
  Future checkFirstSeen() async {
    await Future.delayed(const Duration(seconds: 2));
    finish(context);
    if(isLoged){
    const DashboardScreen().launch(context);
    }else{
    const StartingScreen().launch(context);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex('#FFFFFF'),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(CScloudLogo, height: 150, width: 150).center(),
          Positioned(
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('By', style: secondaryTextStyle()),
                Text('Nagaraj M H', style: boldTextStyle(size: 25, color: Colors.black)),
              ],
            ).paddingBottom(16),
          )
        ],
      ),
    );
  }
}

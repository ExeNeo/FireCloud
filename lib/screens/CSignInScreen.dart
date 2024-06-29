import 'package:cloud/screens/CResetPassword.dart';

import '../../../screens/CDashboardScreen.dart';
import 'package:cloud/screens/CSignUpScreen.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud/auth/auth_service.dart';


class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _email=TextEditingController();
  final _password=TextEditingController();
  bool _passwordVisible = false;
    static final RegExp nameRegExp = RegExp('[a-zA-Z]'); 
  static final RegExp capRegExp = RegExp('[A-Z]'); 
  static final RegExp smallRegExp = RegExp('[a-z]'); 
  static final RegExp spRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+).(*&^%\s-]'); 
  static final RegExp numberRegExp = RegExp(r'\d');
  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  void dispose(){
    super.dispose();
    _email.dispose();
    _password.dispose();

  }


  Future<void> init() async {
    //

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CSCommonAppBar(context, title: "Sign in to $AppName"),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter email address";
                    } else if (!val.validateEmail()) {
                      return "Please enter valid email address";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildInputDecoration("Email"),
                  controller: _email,
                ),
                20.height,
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter password";
                    }
                    if (val.length<8) {
                      return "Password Must be grater than 8 chars";
                    }
                    if (!smallRegExp.hasMatch(val)){
                      return "Password Must have 1 lowercase alphabet";
                    }                    
                    if (!capRegExp.hasMatch(val)){
                      return "Password Must have 1 uppercase alphabet";
                    }
                    if (!spRegExp.hasMatch(val)){
                      return "Password Must have 1 special character";
                    }
                    if (!numberRegExp.hasMatch(val)){
                      return "Password Must have 1 digit";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: 'Password',
      labelStyle: const TextStyle(color: Colors.black),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: CSGreyColor,
        ),
        borderRadius: BorderRadius.zero,
      ),
                    suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
               _passwordVisible
               ? Icons.visibility
               : Icons.visibility_off,
               color: Theme.of(context).primaryColorDark,
               ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   _passwordVisible = !_passwordVisible;
               });}),
                  ),
                  controller: _password,

                  obscureText: !_passwordVisible,
                ),
                20.height,
                authButtonWidget("Sign In").onTap(() {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                }),
                15.height,
                15.height,
                TextButton(
                  onPressed: () {
                    const SignUpScreen().launch(context);
                  },
                  child: Text(
                    "Sign up for cloud",
                    style: boldTextStyle(
                      size: 17,
                      color: CSecondColor,
                    ),
                  ),
                ),
                20.height,
                TextButton(
                  onPressed: () {
                    ResetPasswordScreen().launch(context);
                  },
                  child: Text(
                    "Reset Password",
                    style: boldTextStyle(
                      size: 17,
                      color: CSecondColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null&&mounted) {
      toastLong("Welcome ${user.displayName}");

      const DashboardScreen().launch(context);
    }else{
      
    }
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: CSGreyColor,
        ),
        borderRadius: BorderRadius.zero,
      ),
    );
    
  }
}

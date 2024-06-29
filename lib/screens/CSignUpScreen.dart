
import 'package:cloud/screens/CSignInScreen.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud/auth/auth_service.dart';



class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();
  static final RegExp nameRegExp = RegExp('[a-zA-Z]'); 
  static final RegExp capRegExp = RegExp('[A-Z]'); 
  static final RegExp smallRegExp = RegExp('[a-z]'); 
  static final RegExp spRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+).(*&^%\s-]'); 
  static final RegExp numberRegExp = RegExp(r'\d');
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;


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
  void dispose(){
    super.dispose();
    _email.dispose();
    _password.dispose();
    _lname.dispose();
    _fname.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CSCommonAppBar(context, title: 'Sign up for cloud'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) => value!.isEmpty 
                                          ? 'Enter Your Name'
                                            : ((numberRegExp.hasMatch(value) || spRegExp.hasMatch(value))
                                              ? 'Enter a Valid Name'
                                              :null),
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration("First Name"),
                  controller: _fname,
                ),
                20.height,
                TextFormField(
                  validator: (value) => value!.isEmpty 
                                          ? 'Enter Your Name'
                                            : ((numberRegExp.hasMatch(value) || spRegExp.hasMatch(value)) 
                                              ? 'Enter a Valid Name'
                                              :null),
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration("Last Name"),
                  controller: _lname,

                ),
                20.height,
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration("Email"),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter email address";
                      } else if (!val.validateEmail()) {
                        return "Please enter valid email address";
                      }
                      return null;
                    },
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
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: context.width() * 0.9,
                  decoration: boxDecorationRoundedWithShadow(
                    5,
                    backgroundColor:  CSecondColor,
                    spreadRadius: 1,
                    blurRadius: 0,
                    shadowColor: Colors.grey,
                    offset: const Offset(0, 1),
                  ),
                  height: context.width() * 0.13,
                  child: Text("Sign Up", style: boldTextStyle(color: Colors.white)),
                ).onTap(() {
                  if (_formKey.currentState!.validate()) {
                    _signup();
                    
                  }
                }),
                20.height,
                TextButton(
                  onPressed: () {
                    SignInScreen().launch(context);
                  },
                  child: Text("Sign in", style: boldTextStyle(size: 17, color: CSecondColor)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text,_fname.text,_lname.text);
    if (user != null) {
      await user.updateDisplayName(_fname.text+" "+_lname.text);
      await user.updatePhotoURL("https://firebasestorage.googleapis.com/v0/b/firecloud-v1.appspot.com/o/DEV%2Fphoenix.png?alt=media&token=6b954d5c-dd47-4fab-8cd3-e162d4007226");
      toastLong("Created Succuessfully");
      SignInScreen().launch(context);
      

    }else{
      
    }
  }
}

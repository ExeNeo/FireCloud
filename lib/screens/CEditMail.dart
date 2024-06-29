import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class EditEmail extends StatefulWidget {
  static String tag = '/EditEmail';

  const EditEmail({super.key});

  @override
  EditEmailState createState() => EditEmailState();
}

class EditEmailState extends State<EditEmail> {
  final _formKey = GlobalKey<FormState>();
  final _email=TextEditingController();
    final _password=TextEditingController();
  bool _passwordVisible = false;
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
      appBar: CSCommonAppBar(context, title: "Update Email"),
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
                      return "Please enter password";
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
                  decoration: buildInputDecoration("New Email"),
                  controller: _email,
                ),
                20.height,
                
                20.height,
                authButtonWidget("Change Email").onTap(() {
                  if (_formKey.currentState!.validate()) {
                    _change();
                  }
                }),
                15.height,
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  _change() async {
     try {
      var currentUser = FirebaseAuth.instance.currentUser;
currentUser?.reauthenticateWithCredential(
    EmailAuthProvider.credential(
        email: currentUser.email!,
        password: _password.text,
    ),
);
       await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(_email.text);
     } catch (e) {
     }



      toastLong("Email Sent");
      finish(context);
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

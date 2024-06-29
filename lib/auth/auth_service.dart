import 'package:cloud/auth/firebase_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
class AuthService {
  final _auth = FirebaseAuth.instance;
  // Future<void> session(String uid,String email,String name) async{
  //   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  //   sharedPreferences.setString('uid', uid);
  //   sharedPreferences.setString('email', email);
  //   sharedPreferences.setString('name', name);
    
  // }
  void errorhandle(e){
   dynamic error= AuthExceptionHandler.handleAuthException(e);
   String errorMessage= AuthExceptionHandler.generateErrorMessage(error);
             Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
    );
  }
  Future<User?> createUserWithEmailAndPassword(
      String email, String password,String fname,String lname) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
       errorhandle(e);
    }
    return null;
  }
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
  
      errorhandle(e);
    }
    return null;
  }

  Future<void> fireSignout() async {
    try {
      await _auth.signOut();
      // sharedPreferences.remove('uid', );
      Fluttertoast.showToast(
          msg: 'Signed Out',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
    );
    } catch (e) {
               errorhandle(e);
    }
  }
}

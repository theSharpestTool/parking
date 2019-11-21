import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  static final ProfileProvider _instance = ProfileProvider._internal();
  factory ProfileProvider() => _instance;
  ProfileProvider._internal();

  String _phoneNumber;
  String _code;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCredential _credential;
  String _verificationId;
  bool _codeSend = false;
  FirebaseUser _firebaseUser;

  String get phoneNumber => _phoneNumber;
  bool get codeSend => _codeSend;
  bool get signedIn => _firebaseUser != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('phone');
    _phoneNumber = prefs.getString('phone');
    if (_phoneNumber != null) {
      _codeSend = true;
      await verifyNumber();
      //await signIn();
    } else
      print('no number');
  }

  void setNumber(String number) {
    _phoneNumber = number;
  }

  void setCode(String code) {
    _code = code;
  }

  Future<void> verifyNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        codeAutoRetrievalTimeout: (verId) {
          print('verId: $verId');
        },
        verificationFailed: (e) {
          print('verification failed: ${e.message}');
        },
        verificationCompleted: (cred) async {
          _credential = cred;
          print('verification completed: $cred');
          await signIn();
        },
        codeSent: (verId, [forceCodeResponse]) {
          _verificationId = verId;
          print('code send: id = $verId ; response = $forceCodeResponse');
          _codeSend = true;
          notifyListeners();
        },
        timeout: Duration(seconds: 5),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  void verifyCode() {
    _credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _code,
    );
  }

  Future<void> signIn() async {
    _firebaseUser = (await _auth.signInWithCredential(_credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(_firebaseUser.uid == currentUser.uid);
    if (_firebaseUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', _phoneNumber);
      print('Successfully signed in, uid: ' + _firebaseUser.uid);
    } else
      print('Sign in failed');
  }

  Future<void> signUp() async {
    /*if (!codeSend)
      await verifyNumber();
    else {
      verifyCode();
      await signIn();
    }*/
    if (_codeSend) {
      verifyCode();
      await signIn();
    } else
      await verifyNumber();
    notifyListeners();
  }
}

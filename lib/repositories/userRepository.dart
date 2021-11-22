import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lovely/umsData/verto.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Unintialised,
  Authenticated,
  Authenticating,
  Unauthenticated,
  AuthenticatedButNoProfile,
  FirstTimeApp,
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Status _status = Status.Unintialised;

  UserRepository.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  Future<bool> signIn(
      {required String registration, required String password}) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(
          email: registration + '@email.com', password: password);
      isFirstTime(_firebaseAuth.currentUser!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        Verto verto = Verto('');
        var name =
            await verto.initiater(regNum: registration, password: password);
        if (name != '' && name != null) {
          print(name);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (await prefs.setString('UmsVerifyName', name!.toString())) {
            print('saved UmsVerifyName');
          } else {
            print('failed to save umsVerifyName');
          }
          //initiate signup
          if (await signUp(
              email: registration + '@email.com', password: password)) {
            return true;
            //return true
          } else {
            _status = Status.Unauthenticated;
            notifyListeners();
            return false;
            //return error unauthenticated
          }
        } else {
          _status = Status.Unauthenticated;
          notifyListeners();
          return false;
        }
      } else if (e.code == 'wrong-password') {
        print('wrong-password');
        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  loginThroughOtp(String number) {
    try {
      _firebaseAuth.signInWithPhoneNumber(number);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      isFirstTime(_firebaseAuth.currentUser!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.code.toString());
      return false;
    }
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist = true;
    print("test for new profile of user");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });
    if (!exist) {
      _status = Status.AuthenticatedButNoProfile;
    } else {
      _status = Status.Authenticated;
    }
    notifyListeners();

    return exist;
  }

  Future<void> signOut() async {
    _status = Status.Unauthenticated;
    notifyListeners();
    await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  getUser() {
    return (_firebaseAuth.currentUser)!.uid;
  }

  //profile setup
  Future<bool> profileSetup({
    required File photo,
    required String userId,
    required String name,
    required String gender,
    required String interestedIn,
    required String age,
    required String about,
    required String umsVerifyInfo,
  }) async {
    UploadTask storageUploadTask;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      storageUploadTask = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(userId)
          .child(userId)
          .putFile(photo);

      return await storageUploadTask.then((ref) async {
        await ref.ref.getDownloadURL().then((url) async {
          await _firestore.collection('users').doc(userId).set({
            'uid': userId,
            'photoUrl': url,
            'name': name,
            'gender': gender,
            'interestedIn': interestedIn,
            'age': age,
            'about': about,
            'umsVerifyInfo': umsVerifyInfo,
          });
        });
        isFirstTime(userId);
        return true;
      });
    } on Exception catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  closeintroduction() {
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<bool> isFirstTimeAppOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isFirstTime = preferences.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      preferences.setBool('first_time', false);
      return false;
    } else {
      preferences.setBool('first_time', false);
      return true;
    }
  }

  void _onAuthStateChanged(User? user) async {
    bool introduction = await isFirstTimeAppOpen();
    if (user == null && !introduction) {
      _status = Status.Unauthenticated;
      print('showing login screen');
    } else if (introduction) {
      _status = Status.FirstTimeApp;
      print("showing introduction");
    } else {
      isFirstTime(user!.uid);
    }
    notifyListeners();
  }
}

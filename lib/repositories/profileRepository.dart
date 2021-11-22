import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lovely/models/user.dart';

enum ProfileState { SearchingUser, LoadUser }

class ProfileRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User _currentUser = User(
      about: '',
      age: '',
      gender: '',
      interestedIn: '',
      name: '',
      photo: '',
      uid: '');

  ProfileState searchstate = ProfileState.SearchingUser;
  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  ProfileState get searchState => searchState;

  User get showCurrentUser => _currentUser;
  findUsers({required String uid}) async {
    try {
      _currentUser = await getUserInterests(userId: uid);

      print(" profile user complete ");
      searchstate = ProfileState.LoadUser;
    } on Exception catch (e) {
      print('Error in getting users');
      print(e);
    }
    notifyListeners();
  }

  Future getUserInterests({required userId}) async {
    User currentUser = User(
        about: '',
        age: '',
        gender: '',
        interestedIn: '',
        name: '',
        photo: '',
        uid: '');

    print(userId);
    print('testing1');
    await _firestore.collection('users').doc(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
      currentUser.about = user['about'];
      currentUser.age = user['age'];
    });

    print(currentUser);
    return currentUser;
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
    print('hello there ');
    print(userId);
    try {
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

        return true;
      });
    } on Exception catch (e) {
      print(e);

      return false;
    }
  }
}

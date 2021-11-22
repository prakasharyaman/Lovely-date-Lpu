import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lovely/models/user.dart';

enum MatchState { LoadMatches, FindingMatches }

class MatchesRepository with ChangeNotifier {
  Stream<QuerySnapshot>? matchedList;

  Stream<QuerySnapshot>? selectedList;
  final FirebaseFirestore _firestore;
  MatchState matchState = MatchState.FindingMatches;
  // MatchesRepository.instance() : _firestore = FirebaseFirestore.instance;
  MatchesRepository() : _firestore = FirebaseFirestore.instance;
  // MatchesRepository({FirebaseFirestore? firestore})
  //     : _firestore = firestore ?? FirebaseFirestore.instance;
  MatchState get getMatchState => matchState;
  Stream<QuerySnapshot> get matchListgetter => matchedList!;
  Stream<QuerySnapshot> get selectedListGetter => selectedList!;
  createMatchList({required String userid}) async {
    try {
      matchedList = await getMatchedList(userid);
      selectedList = await getSelectedList(userid);
      print('created match list');
      matchState = MatchState.LoadMatches;
    } on Exception catch (e) {
      print(e);
      print('error in getting a matched list and selected list');
    }
    notifyListeners();
  }

  Future<Stream<QuerySnapshot<Object?>>> getMatchedList(userId) async {
    // ignore: await_only_futures
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('matchedList')
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Object?>>> getSelectedList(userId) async {
    // ignore: await_only_futures
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('selectedList')
        .snapshots();
  }

  Future<User> getUserDetails(userId) async {
    User _user = User(
        about: '',
        age: '',
        gender: '',
        interestedIn: '',
        name: '',
        photo: '',
        uid: '');

    await _firestore.collection('users').doc(userId).get().then((user) {
      _user.uid = user.id;
      _user.name = user['name'];
      _user.photo = user['photoUrl'];
      _user.age = user['age'];
      _user.about = user['about'];
      _user.gender = user['gender'];
      _user.interestedIn = user['interestedIn'];
    });

    return _user;
  }

  Future openChat({required currentUserId, required selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('chats')
        .doc(currentUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .delete();

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .delete();
  }

  void deleteUser(currentUserId, selectedUserId) async {
    try {
      matchState = MatchState.FindingMatches;
      return await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('selectedList')
          .doc(selectedUserId)
          .delete();
    } on Exception catch (e) {
      print(e);
      print('delete user function failed');
    }
    notifyListeners();
  }

  Future selectUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    try {
      deleteUser(currentUserId, selectedUserId);
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('matchedList')
          .doc(selectedUserId)
          .set({
        'name': selectedUserName,
        'photoUrl': selectedUserPhotoUrl,
      });
      matchState = MatchState.FindingMatches;
      return await _firestore
          .collection('users')
          .doc(selectedUserId)
          .collection('matchedList')
          .doc(currentUserId)
          .set({
        'name': currentUserName,
        'photoUrl': currentUserPhotoUrl,
      });
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lovely/models/user.dart';

enum SearchState { SearchingUser, LoadUser }

class SearchRepository with ChangeNotifier {
  User _user = User(
      about: '',
      age: '',
      gender: '',
      interestedIn: '',
      name: '',
      photo: '',
      uid: '');
  User _currentUser = User(
      about: '',
      age: '',
      gender: '',
      interestedIn: '',
      name: '',
      photo: '',
      uid: '');
  final FirebaseFirestore _firestore;
  SearchState searchstate = SearchState.SearchingUser;
  SearchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  SearchState get searchState => searchState;
  User get showUser => _user;
  User get showCurrentUser => _currentUser;
  findUsers({required String uid}) async {
    try {
      _currentUser = await getUserInterests(userId: uid);
      _user = await getUser(userId: uid);
      print("find user complete " + _user.uid + _user.name);
      searchstate = SearchState.LoadUser;
    } on Exception catch (e) {
      print('Error in getting users');
      print(e);
    }
    notifyListeners();
  }

  chooseUser(
      {required currentUserId,
      required selectedUserId,
      required name,
      required photoUrl}) async {
    if (currentUserId != '' &&
        selectedUserId != '' &&
        name != '' &&
        photoUrl != '') {
      try {
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('chosenList')
            .doc(selectedUserId)
            .set({});

        await _firestore
            .collection('users')
            .doc(selectedUserId)
            .collection('chosenList')
            .doc(currentUserId)
            .set({});

        await _firestore
            .collection('users')
            .doc(selectedUserId)
            .collection('selectedList')
            .doc(currentUserId)
            .set({
          'name': name,
          'photoUrl': photoUrl,
        });
        searchstate = SearchState.SearchingUser;
      } on Exception catch (e) {
        print(e);
      }
    } else {
      print('CHOOSE user failed');
      searchstate = SearchState.SearchingUser;
    }
    notifyListeners();
  }

  passUser({required currentUserId, required selectedUserId}) async {
    try {
      if (currentUserId != '' && selectedUserId != '') {
        await _firestore
            .collection('users')
            .doc(selectedUserId)
            .collection('chosenList')
            .doc(currentUserId)
            .set({});

        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('chosenList')
            .doc(selectedUserId)
            .set({});
        searchstate = SearchState.SearchingUser;
      }
    } on Exception catch (e) {
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
    });

    print(currentUser);
    return currentUser;
  }

  Future<List<String>> getChosenList({required userId}) async {
    List<String> chosenList = [];
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chosenList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        chosenList.add(doc.id);
      }
    });
    return chosenList;
  }

  Future<User> getUser({required userId}) async {
    User _user = User(
        about: '',
        age: '',
        gender: '',
        interestedIn: '',
        name: '',
        photo: '',
        uid: '');
    List<String> chosenList = await getChosenList(
      userId: userId,
    );
    User currentUser = await getUserInterests(
      userId: userId,
    );

    await _firestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        if ((!chosenList.contains(user.id)) &&
            (user.id != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          _user.uid = user.id;
          _user.name = user['name'];
          _user.photo = user['photoUrl'];
          _user.age = user['age'];
          _user.about = user['about'];
          _user.gender = user['gender'];
          _user.interestedIn = user['interestedIn'];
          break;
        }
      }
    });

    return _user;
  }
}

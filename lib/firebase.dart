import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebadecrudoperation/constant/firebase%20_constant.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class UserManagement {
  final CollectionReference _collectionReference =
      kFirebaseStore.collection('users');

  final BehaviorSubject<List<DocumentSnapshot>> _userSubject =
      BehaviorSubject<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get users => _userSubject.stream;

  Future<void> addUser(Map<String, dynamic> userData) async {
    await _collectionReference.add(userData);
  }

  Future<void> updateUser(
      Map<String, dynamic> userData, String documentId) async {
    await _collectionReference.doc(documentId).update(userData);
  }

  Future<void> deleteUser(String documentId) async {
    await _collectionReference.doc(documentId).delete();
  }

  void listenToUsers() {
    _collectionReference.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _userSubject.add(snapshot.docs);
      } else {
        _userSubject.addError("No Users Found");
      }
    });
  }

  void dispose() {
    _userSubject.close();
  }
}

class UserManagementProvider extends InheritedWidget {
  final UserManagement userManagement;
  final Widget child;
  const UserManagementProvider({
    required this.child,
    required this.userManagement,
    Key? key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserManagement of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<UserManagementProvider>()
              as UserManagementProvider)
          .userManagement;
}

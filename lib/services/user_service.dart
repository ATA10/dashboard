import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection("users").doc(user.uid).get();

      return {
        'displayName': userDoc.data()?['displayName'] ?? user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
      };
    }
    return null;
  }

  Future<void> updateUserData({String? displayName}) async {
    User? user = _auth.currentUser;
    if (user != null && displayName != null) {
      await user.updateDisplayName(displayName);
      await _firestore.collection("users").doc(user.uid).update({
        'displayName': displayName,
      });
    }
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).delete();
      await user.delete();
    }
  }
}

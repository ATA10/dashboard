import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Kullanıcı giriş yapma fonksiyonu
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Giriş yapılamadı.";
    }
  }

  /// Kullanıcı kayıt olma fonksiyonu (Firestore'a da kaydediyor)
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email.trim(),
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Kayıt yapılamadı.";
    }
  }

  /// Kullanıcı çıkış yapma fonksiyonu
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Şu an oturum açmış olan kullanıcıyı getir
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcının UID'sini al ve kullanıcıya özel document'i döndür
  Future<DocumentReference> getUserDocument() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection("users").doc(user.uid);
    } else {
      throw Exception("Kullanıcı giriş yapmamış.");
    }
  }

  // Koleksiyon adı ile veri çekme (get)
  Future<List<String>> fetchData(String collectionName) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      QuerySnapshot snapshot = await userDoc.collection(collectionName).get();
      return snapshot.docs.map((doc) => doc["task"] as String).toList(); // Data "task" field'ından alınıyor
    } catch (e) {
      throw Exception("Veri çekilemedi: $e");
    }
  }

  // Yeni veri ekleme (create)
  Future<void> addTask(String collectionName, String taskName) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection(collectionName).add({
        "task": taskName,
        "createdAt": FieldValue.serverTimestamp(), // Eklenen verinin zaman damgası
      });
    } catch (e) {
      throw Exception("Veri eklenemedi: $e");
    }
  }

  // Veri güncelleme (update)
  Future<void> updateTask(String collectionName, String taskId, String newTaskName) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection(collectionName).doc(taskId).update({
        "task": newTaskName,
      });
    } catch (e) {
      throw Exception("Veri güncellenemedi: $e");
    }
  }

  // Veri silme (delete)
  Future<void> deleteTask(String collectionName, String taskId) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection(collectionName).doc(taskId).delete();
    } catch (e) {
      throw Exception("Veri silinemedi: $e");
    }
  }
}



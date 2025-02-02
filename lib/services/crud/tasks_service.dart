// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TasksFirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Kullanıcının UID'sini al ve kullanıcıya özel document'i döndür
//   Future<DocumentReference> getUserDocument() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return _firestore.collection("users").doc(user.uid);
//     } else {
//       throw Exception("Kullanıcı giriş yapmamış.");
//     }
//   }

//   // İşler koleksiyonundan veri çekme
//   Future<List<Map<String, dynamic>>> fetchTasks() async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       QuerySnapshot snapshot = await userDoc.collection("tasks").get();

//       return snapshot.docs.map((doc) {
//         return {
//           'taskId': doc.id,
//           'task': doc["task"],
//           'createdAt': (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//         };
//       }).toList();
//     } catch (e) {
//       throw Exception("Veri çekilemedi: $e");
//     }
//   }

//   // Yeni görev ekleme
//   Future<void> addTask(String taskName) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("tasks").add({
//         "task": taskName,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Veri eklenemedi: $e");
//     }
//   }

//   // Görev güncelleme
//   Future<void> updateTask(String taskId, String newTaskName) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("tasks").doc(taskId).update({
//         "task": newTaskName,
//       });
//     } catch (e) {
//       throw Exception("Veri güncellenemedi: $e");
//     }
//   }

//   // Görev silme
//   Future<void> deleteTask(String taskId) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("tasks").doc(taskId).delete();
//     } catch (e) {
//       throw Exception("Veri silinemedi: $e");
//     }
//   }
// }

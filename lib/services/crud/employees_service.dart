// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class EmployeesFirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<DocumentReference> getUserDocument() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       return _firestore.collection("users").doc(user.uid);
//     } else {
//       throw Exception("Kullanıcı giriş yapmamış.");
//     }
//   }

//   // ✅ Çalışan verilerini çekme fonksiyonu
//   Future<List<Map<String, dynamic>>> fetchEmployees() async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       QuerySnapshot snapshot = await userDoc.collection("employees").get();
//       return snapshot.docs.map((doc) {
//         return {
//           'employeeId': doc.id,
//           'name': doc["name"],
//           'position': doc["position"],
//           'createdAt': (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//         };
//       }).toList();
//     } catch (e) {
//       throw Exception("Veri çekilemedi: $e");
//     }
//   }

//   // Çalışanı güncellemek için metod
//   Future<void> updateEmployee(String employeeId, String newName, String newPosition) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("employees").doc(employeeId).update({
//         "name": newName,
//         "position": newPosition,
//       });
//     } catch (e) {
//       throw Exception("Çalışan güncellenemedi: $e");
//     }
//   }

//   // Çalışanı silmek için metod
//   Future<void> deleteEmployee(String employeeId) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("employees").doc(employeeId).delete();
//     } catch (e) {
//       throw Exception("Çalışan silinemedi: $e");
//     }
//   }
// }

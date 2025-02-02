// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FinanceFirestoreService {
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

//   Future<List<Map<String, dynamic>>> fetchFinance() async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       QuerySnapshot snapshot = await userDoc.collection("finance").get();
//       return snapshot.docs.map((doc) {
//         return {
//           'financeId': doc.id,
//           'amount': doc["amount"],
//           'createdAt': (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//         };
//       }).toList();
//     } catch (e) {
//       throw Exception("Veri çekilemedi: $e");
//     }
//   }

//   Future<void> addFinance(double amount) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("finance").add({
//         "amount": amount,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Veri eklenemedi: $e");
//     }
//   }

//   Future<void> updateFinance(String financeId, double newAmount) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("finance").doc(financeId).update({
//         "amount": newAmount,
//       });
//     } catch (e) {
//       throw Exception("Veri güncellenemedi: $e");
//     }
//   }

//   Future<void> deleteFinance(String financeId) async {
//     try {
//       DocumentReference userDoc = await getUserDocument();
//       await userDoc.collection("finance").doc(financeId).delete();
//     } catch (e) {
//       throw Exception("Veri silinemedi: $e");
//     }
//   }
// }

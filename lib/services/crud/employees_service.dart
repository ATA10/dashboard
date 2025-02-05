import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Çalışanları Firestore’dan çek
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection("users").doc(userId).get();

      if (!snapshot.exists || snapshot.data() == null) return [];

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic>? employees = data["employees"];

      if (employees == null) return [];

      return employees.entries.map((entry) {
        return {
          "employeeId": entry.key,
          "name": entry.value["name"],
          "position": entry.value["position"],
          "email": entry.value["email"],
          "phone": entry.value["phone"],
          "timestamp": entry.value["timestamp"] ?? "",
        };
      }).toList();
    } catch (e) {
      print("Hata oluştu: $e");
      return [];
    }
  }

  // 🔹 Yeni çalışan ekle
  Future<void> addItem(String name, String position, String email, String phone) async {
    String newEmployeeId = _firestore.collection("users").doc(userId).collection("employees").doc().id;
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "employees.$newEmployeeId": {
        "name": name,
        "position": position,
        "email": email,
        "phone": phone,
        "timestamp": now, // ✅ Tarih ekliyoruz
      }
    });
  }

  // 🔹 Çalışan bilgilerini güncelle
  Future<void> updateItem(String employeeId, String name, String position, String email, String phone) async {
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "employees.$employeeId.name": name,
      "employees.$employeeId.position": position,
      "employees.$employeeId.email": email,
      "employees.$employeeId.phone": phone,
      "employees.$employeeId.timestamp": now, // ✅ Güncelleme tarihi ekleniyor
    });
  }

  // 🔹 Çalışanı sil
  Future<void> deleteItem(String employeeId) async {
    await _firestore.collection("users").doc(userId).update({
      "employees.$employeeId": FieldValue.delete()
    });
  }
}

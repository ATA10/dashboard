import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DevicesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Cihazları Firestore’dan çek
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection("users").doc(userId).get();

      if (!snapshot.exists || snapshot.data() == null) return [];

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic>? devices = data["devices"];

      if (devices == null) return [];

      return devices.entries.map((entry) {
        return {
          "deviceId": entry.key,
          "name": entry.value["name"],
          "model": entry.value["model"],
          "serial": entry.value["serial"],
          "location": entry.value["location"],
          "timestamp": entry.value["timestamp"] ?? "",
        };
      }).toList();
    } catch (e) {
      print("Hata oluştu: $e");
      return [];
    }
  }

  // 🔹 Yeni cihaz ekle
  Future<void> addItem(String name, String model, String serial, String location) async {
    String newDeviceId = _firestore.collection("users").doc(userId).collection("devices").doc().id;
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "devices.$newDeviceId": {
        "name": name,
        "model": model,
        "serial": serial,
        "location": location,
        "timestamp": now, // ✅ Tarih ekliyoruz
      }
    });
  }

  // 🔹 Cihaz bilgilerini güncelle
  Future<void> updateItem(String deviceId, String name, String model, String serial, String location) async {
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "devices.$deviceId.name": name,
      "devices.$deviceId.model": model,
      "devices.$deviceId.serial": serial,
      "devices.$deviceId.location": location,
      "devices.$deviceId.timestamp": now, // ✅ Güncelleme tarihi ekleniyor
    });
  }

  // 🔹 Cihazı sil
  Future<void> deleteItem(String deviceId) async {
    await _firestore.collection("users").doc(userId).update({
      "devices.$deviceId": FieldValue.delete()
    });
  }
}
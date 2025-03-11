// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DevicesFirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = FirebaseAuth.instance.currentUser!.uid;

//   // 🔹 Cihazları Firestore’dan çek
//   Future<List<Map<String, dynamic>>> fetchData() async {
//     try {
//       DocumentSnapshot snapshot = await _firestore.collection("users").doc(userId).get();

//       if (!snapshot.exists || snapshot.data() == null) return [];

//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       Map<String, dynamic>? devices = data["devices"];

//       if (devices == null) return [];

//       return devices.entries.map((entry) {
//         return {
//           "deviceId": entry.key,
//           "name": entry.value["name"],
//           "model": entry.value["model"],
//           "serial": entry.value["serial"],
//           "location": entry.value["location"],
//           "timestamp": entry.value["timestamp"] ?? "",
//         };
//       }).toList();
//     } catch (e) {
//       print("Hata oluştu: $e");
//       return [];
//     }
//   }

//   // 🔹 Yeni cihaz ekle
//   Future<void> addItem(String name, String model, String serial, String location) async {
//     String newDeviceId = _firestore.collection("users").doc(userId).collection("devices").doc().id;
//     Timestamp now = Timestamp.now();

//     await _firestore.collection("users").doc(userId).update({
//       "devices.$newDeviceId": {
//         "name": name,
//         "model": model,
//         "serial": serial,
//         "location": location,
//         "timestamp": now, // ✅ Tarih ekliyoruz
//       }
//     });
//   }

//   // 🔹 Cihaz bilgilerini güncelle
//   Future<void> updateItem(String deviceId, String name, String model, String serial, String location) async {
//     Timestamp now = Timestamp.now();

//     await _firestore.collection("users").doc(userId).update({
//       "devices.$deviceId.name": name,
//       "devices.$deviceId.model": model,
//       "devices.$deviceId.serial": serial,
//       "devices.$deviceId.location": location,
//       "devices.$deviceId.timestamp": now, // ✅ Güncelleme tarihi ekleniyor
//     });
//   }

//   // 🔹 Cihazı sil
//   Future<void> deleteItem(String deviceId) async {
//     await _firestore.collection("users").doc(userId).update({
//       "devices.$deviceId": FieldValue.delete()
//     });
//   }
// }


// // // users koleksiyonu
// // users: {
// //   zWLdCoO0BmUDHUw5QI00fY5kyX82: {
// //     createdAt: "March 11, 2025 at 1:16:19 PM UTC+3",
// //     email: "asd12@gmail.com",
// //     uid: "zWLdCoO0BmUDHUw5QI00fY5kyX82",
// //     devices: {
// //       LCLItwlCUlF0aNn6ErSO: {
// //         name: "cihaz1",
// //         model: "ch1",
// //         serial: "123456",
// //         location: "bal",
// //         timestamp: "March 11, 2025 at 1:27:41 PM UTC+3"
// //       }
// //     }
// //   }
// // }

// // // devices koleksiyonu
// // devices: {
// //   LCLItwlCUlF0aNn6ErSO: {
// //     relays: {
// //       relay1: false,
// //       relay2: false,
// //       relay3: false
// //     },
// //     sensors: {
// //       humidity: "754",
// //       temperature: "0.00"
// //     }
// //   }
// // }



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

Future<void> addItem(String name, String model, String serial, String location) async {
  try {
    // devices koleksiyonunda belirli bir serial numarasına sahip cihaz var mı kontrol et
    DocumentSnapshot deviceSnapshot = await _firestore
        .collection("devices")
        .doc(serial)  // serial numarası cihazın ID'si olarak kullanılıyor
        .get();

    if (deviceSnapshot.exists) {
      // Eğer cihaz varsa, cihazı "users" koleksiyonundaki devices alanına ekle veya güncelle
      Timestamp now = Timestamp.now();

      await _firestore.collection("users").doc(userId).update({
        "devices.$serial": {
          "name": name,
          "model": model,
          "serial": serial,
          "location": location,
          "timestamp": now, // ✅ Cihazın eklenme veya güncellenme zamanı
        }
      });

      print("Cihaz başarıyla kaydedildi veya güncellendi.");
    } else {
      // Eğer cihaz yoksa, kayıt yapma ve kullanıcıya bilgi ver
      print("Cihaz bulunamadı! Veritabanında böyle bir cihaz yok. Kontrol edilen serial: $serial");
      print("Cihaz kaydedilmedi.");
    }
  } catch (e) {
    print("Hata oluştu: $e");
  }
}

  // 🔹 Relay verisini güncelle
  Future<void> updateRelayState(String deviceId, String relayId, bool state) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'relays.$relayId': state,  // Dynamically update the relay state
      });
    } catch (e) {
      print("Relay güncellenemedi: $e");
    }
  }

  // 🔹 Cihaz bilgilerini güncelle
  Future<void> updateItem(String deviceId, String name, String model, String serial, String location) async {
    Timestamp now = Timestamp.now();

    // Kullanıcı cihazını güncelle
    await _firestore.collection("users").doc(userId).update({
      "devices.$deviceId.name": name,
      "devices.$deviceId.model": model,
      "devices.$deviceId.serial": serial,
      "devices.$deviceId.location": location,
      "devices.$deviceId.timestamp": now, // ✅ Güncelleme tarihi
    });
  }

  // 🔹 Cihazı sil
  Future<void> deleteItem(String deviceId) async {
    // Kullanıcı cihazını sil
    await _firestore.collection("users").doc(userId).update({
      "devices.$deviceId": FieldValue.delete(),
    });
  }
}

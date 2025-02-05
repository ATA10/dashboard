import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentReference> getUserDocument() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection("users").doc(user.uid);
    } else {
      throw Exception("Kullanıcı giriş yapmamış.");
    }
  }

  Future<List<Map<String, dynamic>>> fetchCalendar() async {
    try {
      DocumentReference userDoc = await getUserDocument();
      QuerySnapshot snapshot = await userDoc.collection("calendar").get();
      return snapshot.docs.map((doc) {
        return {
          'calendarId': doc.id,
          'event': doc["event"],
          'eventDate': (doc['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();
    } catch (e) {
      throw Exception("Veri çekilemedi: $e");
    }
  }

  Future<void> addEvent(String eventName, DateTime eventDate) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection("calendar").add({
        "event": eventName,
        "eventDate": eventDate,
      });
    } catch (e) {
      throw Exception("Veri eklenemedi: $e");
    }
  }

  Future<void> updateEvent(String calendarId, String newEventName) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection("calendar").doc(calendarId).update({
        "event": newEventName,
      });
    } catch (e) {
      throw Exception("Veri güncellenemedi: $e");
    }
  }

  Future<void> deleteEvent(String calendarId) async {
    try {
      DocumentReference userDoc = await getUserDocument();
      await userDoc.collection("calendar").doc(calendarId).delete();
    } catch (e) {
      throw Exception("Veri silinemedi: $e");
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodolistFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(userId).get();

      if (!snapshot.exists || snapshot.data() == null) {
        return [];
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic>? todoList = data["todolist"];

      if (todoList == null) {
        return [];
      }

      return todoList.entries.map((entry) {
        return {
          "taskId": entry.key,
          "task": entry.value["task"],
          "timestamp": entry.value["timestamp"] ?? "",
        };
      }).toList();
    } catch (e) {
      print("Hata oluştu: $e");
      return [];
    }
  }

  Future<void> addItem(String task) async {
    String newTaskId = _firestore.collection("users").doc(userId).collection("todolist").doc().id;
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "todolist.$newTaskId": {
        "task": task,
        "timestamp": now, // 🔥 Anlık tarih ve saat eklendi!
      }
    });
  }

  Future<void> updateItem(String taskId, String newTask) async {
    Timestamp now = Timestamp.now();

    await _firestore.collection("users").doc(userId).update({
      "todolist.$taskId.task": newTask,
      "todolist.$taskId.timestamp": now, // 🔥 Güncellemede de tarih değiştirildi!
    });
  }

  Future<void> deleteItem(String taskId) async {
    await _firestore.collection("users").doc(userId).update({
      "todolist.$taskId": FieldValue.delete()
    });
  }
}

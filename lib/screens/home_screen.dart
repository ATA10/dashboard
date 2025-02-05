import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

import '../widgets/todolist_expandable_card.dart';
import '../services/crud/todolist_firestore_service.dart';

import '../widgets/employees_card_widget.dart';
import '../services/crud/employees_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExpandableCardWidget(
              title: "ToDo List",
              // collectionName: "todolist",
              firestoreService: TodolistFirestoreService(),
            ),
            SizedBox(height: 16), // Araya boşluk ekledim
            EmployeesCardWidget(
              firestoreService: EmployeesFirestoreService(),
            ),
          ],
        ),
      ),
    );
  }
}
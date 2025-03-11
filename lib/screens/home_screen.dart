import 'package:dashboard/services/crud/devices_firestore_services.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/todolist_expandable_card.dart';
import '../services/crud/todolist_firestore_service.dart';
import '../widgets/employees_card_widget.dart';
import '../services/crud/employees_service.dart';
import '../widgets/calendar_card_widget.dart'; // Takvim widget'ı
import '../widgets/devices/devices_card_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarCardWidget(), 
            SizedBox(height: 16),
            ExpandableCardWidget(
              title: "ToDo List",
              firestoreService: TodolistFirestoreService(),
            ),
            SizedBox(height: 16), // Araya boşluk ekledim
            EmployeesCardWidget(
              firestoreService: EmployeesFirestoreService(),
            ),
            SizedBox(height: 10),
            DevicesCardWidget(
              firestoreService: DevicesFirestoreService(),
            ),
          ],
        ),
      ),
    );
  }
}

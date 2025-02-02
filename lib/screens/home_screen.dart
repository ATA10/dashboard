import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/expandable_card.dart';
// import '../services/crud/calendar_service.dart';
// import '../services/crud/employees_service.dart';
// import '../services/crud/finance_service.dart';
// import '../services/crud/tasks_service.dart';
import '../services/crud/todolist_firestore_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ExpandableCardWidget(
            //   title: "İşler",
            //   collectionName: "tasks",
            //   firestoreService: TasksFirestoreService(),
            // ),
            // ExpandableCardWidget(
            //   title: "Çalışanlar",
            //   collectionName: "employees",
            //   firestoreService: EmployeesFirestoreService(),
            // ),
            // ExpandableCardWidget(
            //   title: "Mali Durum",
            //   collectionName: "finance",
            //   firestoreService: FinanceFirestoreService(),
            // ),
            // ExpandableCardWidget(
            //   title: "Takvim",
            //   collectionName: "calendar",
            //   firestoreService: CalendarFirestoreService(),
            // ),
            ExpandableCardWidget(
              title: "ToDo List",
              // collectionName: "todolist",
              firestoreService: TodolistFirestoreService(),
            ),
          ],
        ),
      ),
    );
  }
}
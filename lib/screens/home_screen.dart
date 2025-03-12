import 'package:dashboard/services/crud/devices_firestore_services.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/todo_list/todolist_expandable_card.dart';
import '../services/crud/todolist_firestore_service.dart';
import '../widgets/employees/employees_card_widget.dart';
import '../services/crud/employees_service.dart';
import '../widgets/calendar/calendar_card_widget.dart';
import '../widgets/devices/devices_card_widget.dart';
import '../widgets/navigation_bar.dart'; 
import '../screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Burada NavigationBar'da seçilen sekme ile ilgili işlemleri yapabilirsiniz.
    // Örneğin, farklı sayfalara yönlendirme veya farklı içerikler gösterme.
    if (index == 0) {
      // Ana Sayfa (Zaten buradayız)
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    } else if (index == 2) {
      // Çıkış (Çıkış işlemini NavigationBar içinde zaten yapıyoruz)
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(title: 'Ana Sayfa'),
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarCardWidget(),
                SizedBox(height: 16),
                ExpandableCardWidget(
                  title: "ToDo List",
                  firestoreService: TodolistFirestoreService(),
                ),
                SizedBox(height: 16),
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ),
      ],
    ),
  );
}

}
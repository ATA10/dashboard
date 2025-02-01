import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/expandable_card.dart'; // Yeni widget'ı içe aktardık.

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ana Sayfa"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExpandableCardWidget(title: "İşler", collectionName: "tasks"),
            ExpandableCardWidget(title: "Çalışanlar", collectionName: "employees"),
            ExpandableCardWidget(title: "Mali Durum", collectionName: "finance"),
            ExpandableCardWidget(title: "Takvim", collectionName: "calendar"),
            ExpandableCardWidget(title: "ToDo List", collectionName: "todo_list"),
          ],
        ),
      ),
    );
  }
}

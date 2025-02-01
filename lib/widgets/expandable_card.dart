import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpandableCardWidget extends StatefulWidget {
  final String title;
  final String collectionName; // Firestore koleksiyon adı

  ExpandableCardWidget({required this.title, required this.collectionName});

  @override
  _ExpandableCardWidgetState createState() => _ExpandableCardWidgetState();
}

class _ExpandableCardWidgetState extends State<ExpandableCardWidget> {
  bool _isExpanded = false;

  Future<List<String>> _fetchData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(widget.collectionName).get();
    return snapshot.docs.map((doc) => doc["name"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.blueAccent,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            FutureBuilder<List<String>>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Veri alınırken hata oluştu."),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Veri bulunamadı."),
                  );
                }

                return Column(
                  children: snapshot.data!.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text(item, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

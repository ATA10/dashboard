import 'package:flutter/material.dart';

class ExpandableCardWidget extends StatefulWidget {
  final String title;
  final dynamic firestoreService;

  ExpandableCardWidget({required this.title, required this.firestoreService});

  @override
  _ExpandableCardWidgetState createState() => _ExpandableCardWidgetState();
}

class _ExpandableCardWidgetState extends State<ExpandableCardWidget> {
  bool _isExpanded = false;
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _dataFuture = widget.firestoreService.fetchData();
    });
  }

  void _addItem() async {
    TextEditingController _textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Yeni ${widget.title} Ekle"),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "${widget.title} Adı",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_textController.text.trim().isNotEmpty) {
                await widget.firestoreService.addItem(_textController.text.trim());
                _fetchData();
                Navigator.pop(context);
              }
            },
            child: Text("Ekle"),
          ),
        ],
      ),
    );
  }

  void _updateItem(String taskId, String oldValue) async {
    TextEditingController _textController = TextEditingController(text: oldValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${widget.title} Güncelle"),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Yeni değer",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_textController.text.trim().isNotEmpty) {
                await widget.firestoreService.updateItem(taskId, _textController.text.trim());
                _fetchData();
                Navigator.pop(context);
              }
            },
            child: Text("Güncelle"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String taskId) async {
    await widget.firestoreService.deleteItem(taskId);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.add, color: Colors.green), onPressed: _addItem),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Veri alınırken hata oluştu."));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Veri bulunamadı."));
                  }
                  return Column(
                    children: snapshot.data!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                          ),
                          child: ListTile(
                            leading: Icon(Icons.circle, size: 12, color: Colors.blueAccent),
                            title: Text(
                              item['task'] ?? "",
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _updateItem(item['taskId'], item['task']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteItem(item['taskId']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

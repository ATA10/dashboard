import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/crud/employees_service.dart';
import 'employee_form_widget.dart';

class EmployeesCardWidget extends StatefulWidget {
  final EmployeesFirestoreService firestoreService;

  EmployeesCardWidget({required this.firestoreService});

  @override
  _EmployeesCardWidgetState createState() => _EmployeesCardWidgetState();
}

class _EmployeesCardWidgetState extends State<EmployeesCardWidget> {
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

  void _addEmployee() {
    showDialog(
      context: context,
      builder: (context) => EmployeeFormWidget(
        onSubmit: (name, position, email, phone) async {
          await widget.firestoreService.addItem(name, position, email, phone);
          _fetchData();
        },
      ),
    );
  }

  void _updateEmployee(String employeeId, Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFormWidget(
        employeeId: employeeId,
        name: employee['name'],
        position: employee['position'],
        email: employee['email'],
        phone: employee['phone'],
        onSubmit: (name, position, email, phone) async {
          await widget.firestoreService.updateItem(employeeId, name, position, email, phone);
          _fetchData();
        },
      ),
    );
  }

  void _deleteEmployee(String employeeId) async {
    await widget.firestoreService.deleteItem(employeeId);
    _fetchData();
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Bilinmiyor";
    try {
      DateTime date = (timestamp as Timestamp).toDate();
      return DateFormat("dd MMM yyyy, HH:mm").format(date);
    } catch (e) {
      return "Bilinmiyor";
    }
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
            title: Text("Çalışanlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.add, color: Colors.green), onPressed: _addEmployee),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.blueAccent),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(padding: const EdgeInsets.all(8.0), child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Padding(padding: const EdgeInsets.all(8.0), child: Text("Veri alınırken hata oluştu."));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(8.0), child: Text("Çalışan bulunamadı."));
                }

                return Column(
                  children: snapshot.data!.map((employee) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 20, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(employee['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(employee['position'], style: TextStyle(color: Colors.grey[600])),
                                Text(employee['email'], style: TextStyle(color: Colors.grey[600])),
                                Text(employee['phone'], style: TextStyle(color: Colors.grey[600])),
                                Text("Eklenme Tarihi: ${formatTimestamp(employee['timestamp'])}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _updateEmployee(employee['employeeId'], employee)),
                          IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteEmployee(employee['employeeId'])),
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

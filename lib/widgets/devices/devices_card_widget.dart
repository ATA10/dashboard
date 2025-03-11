import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/crud/devices_firestore_services.dart';
import 'devices_form_widget.dart';

class DevicesCardWidget extends StatefulWidget {
  final DevicesFirestoreService firestoreService;

  DevicesCardWidget({required this.firestoreService});

  @override
  _DevicesCardWidgetState createState() => _DevicesCardWidgetState();
}

class _DevicesCardWidgetState extends State<DevicesCardWidget> {
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

  void _addDevice() {
    showDialog(
      context: context,
      builder: (context) => DeviceFormWidget(
        onSubmit: (name, model, serial, location) async {
          await widget.firestoreService.addItem(name, model, serial, location);
          _fetchData();
        },
      ),
    );
  }

  void _updateDevice(String deviceId, Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => DeviceFormWidget(
        deviceId: deviceId,
        name: device['name'],
        model: device['model'],
        serial: device['serial'],
        location: device['location'],
        onSubmit: (name, model, serial, location) async {
          await widget.firestoreService.updateItem(deviceId, name, model, serial, location);
          _fetchData();
        },
      ),
    );
  }

  void _deleteDevice(String deviceId) async {
    await widget.firestoreService.deleteItem(deviceId);
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
            title: Text("Cihazlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.add, color: Colors.green), onPressed: _addDevice),
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
                  return Padding(padding: const EdgeInsets.all(8.0), child: Text("Cihaz bulunamadı."));
                }

                return Column(
                  children: snapshot.data!.map((device) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.devices, size: 20, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(device['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                // Text("Model: ${device['model']}", style: TextStyle(color: Colors.grey[600])),
                                // Text("Seri No: ${device['serial']}", style: TextStyle(color: Colors.grey[600])),
                                // Text("Konum: ${device['location']}", style: TextStyle(color: Colors.grey[600])),
                                // Text("Eklenme Tarihi: ${formatTimestamp(device['timestamp'])}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _updateDevice(device['deviceId'], device)),
                          IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteDevice(device['deviceId'])),
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

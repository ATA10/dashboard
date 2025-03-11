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
  ScrollController _scrollController = ScrollController();

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

  void _updateRelay(String deviceId, String relayId, bool state) async {
    await widget.firestoreService.updateRelayState(deviceId, relayId, state);
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

  String _formatSensorValue(String sensorName, dynamic value) {
    switch (sensorName.toLowerCase()) {
      case 'temperature':
        return "$value °C"; // Sıcaklık için birim ekle
      case 'humidity':
        return "$value %"; // Nem için birim ekle
      case 'pressure':
        return "$value hPa"; // Basınç için birim ekle
      default:
        return value.toString(); // Diğer durumlarda değeri olduğu gibi göster
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: _isExpanded ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Card(
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
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      if (_isExpanded) {
                        Future.delayed(Duration(milliseconds: 300), () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        });
                      }
                    },
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
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = true;
                          });
                          Future.delayed(Duration(milliseconds: 300), () {
                            _scrollController.animateTo(
                              0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          });
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.grey[200], // Arka plan rengini biraz daha koyu yap
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(device['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _updateDevice(device['deviceId'], device)),
                                        IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteDevice(device['deviceId'])),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10), // Boşluk ekle
                                Row(
                                  children: [
                                    // Röleler için sütun
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (device['relays'] != null && device['relays'].isNotEmpty)
                                            ...device['relays'].entries.map((relay) {
                                              return Row(
                                                children: [
                                                  Text(relay.key, style: TextStyle(fontSize: 14)),
                                                  Switch(
                                                    value: relay.value,
                                                    onChanged: (bool newValue) {
                                                      _updateRelay(device['deviceId'], relay.key, newValue);
                                                    },
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          if (device['relays'] == null || device['relays'].isEmpty)
                                            Text("Röle bulunamadı.", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    // Sensörler için sütun
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (device['sensors'] != null && device['sensors'].isNotEmpty)
                                            ...device['sensors'].entries.map((sensor) {
                                              return Row(
                                                children: [
                                                  Text(sensor.key, style: TextStyle(fontSize: 14)),
                                                  Text(": ${sensor.value}", style: TextStyle(fontSize: 14)),
                                                ],
                                              );
                                            }).toList(),
                                          if (device['sensors'] == null || device['sensors'].isEmpty)
                                            Text("Sensör bulunamadı.", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
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
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


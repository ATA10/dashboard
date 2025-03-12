import 'package:flutter/material.dart';
import '../sensor_arc_widget.dart';

class DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;
  final Function(String deviceId, Map<String, dynamic> device) updateDevice;
  final Function(String deviceId) deleteDevice;
  final Function(String deviceId, String relayKey, bool newValue) updateRelay;
  final double Function(String sensorKey) getMaxSensorValue;
  final Color Function(String sensorKey) getSensorColor;

  DeviceCard({
    required this.device,
    required this.updateDevice,
    required this.deleteDevice,
    required this.updateRelay,
    required this.getMaxSensorValue,
    required this.getSensorColor,
  });

  
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

  
  double _getMaxSensorValue(String sensorName) {
    switch (sensorName.toLowerCase()) {
      case 'temperature':
        return 100;
      case 'humidity':
        return 100;
      case 'pressure':
        return 2000;
      default:
        return 100;
    }
  }

  Color _getSensorColor(String sensorName) {
    switch (sensorName.toLowerCase()) {
      case 'temperature':
        return Colors.red;
      case 'humidity':
        return Colors.blue;
      case 'pressure':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
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
                    IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => updateDevice(device['deviceId'], device)),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => deleteDevice(device['deviceId'])),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
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
                                  updateRelay(device['deviceId'], relay.key, newValue);
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sensörler için SensorArc widget'ını kullanma
                      if(device['sensors'] != null && device['sensors'].isNotEmpty)
                        Wrap(spacing: 10, children: (device['sensors'] as Map<String, dynamic>).entries.map((sensor) {
                          // String değeri double'a dönüştür
                          double sensorValue = double.tryParse(sensor.value.toString()) ?? 0.0;
                          return SensorArc(
                            value: sensorValue,
                            maxValue: _getMaxSensorValue(sensor.key),
                            label: sensor.key,
                            arcColor: _getSensorColor(sensor.key),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SensorArc extends StatelessWidget {
  final double value;
  final double maxValue;
  final String label;
  final Color arcColor;

  SensorArc({
    required this.value,
    required this.maxValue,
    required this.label,
    required this.arcColor,
  });

  @override
  Widget build(BuildContext context) {
    // SensorArc'ın görselleştirme kodunu buraya ekleyin.
    // Örnek olarak basit bir Text widget'ı kullanıyorum.
    return Column(
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        // Burada SensorArc'ın görselleştirme kodunu ekleyebilirsiniz.
      ],
    );
  }
}
// import 'package:flutter/material.dart';

// class DeviceFormWidget extends StatefulWidget {
//   final String? deviceId;
//   final String? name;
//   final String? model;
//   final String? serial;
//   final String? location;
//   final Function(String, String, String, String) onSubmit;

//   DeviceFormWidget({
//     this.deviceId,
//     this.name,
//     this.model,
//     this.serial,
//     this.location,
//     required this.onSubmit,
//   });

//   @override
//   _DeviceFormWidgetState createState() => _DeviceFormWidgetState();
// }

// class _DeviceFormWidgetState extends State<DeviceFormWidget> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _modelController = TextEditingController();
//   final TextEditingController _serialController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.name != null) _nameController.text = widget.name!;
//     if (widget.model != null) _modelController.text = widget.model!;
//     if (widget.serial != null) _serialController.text = widget.serial!;
//     if (widget.location != null) _locationController.text = widget.location!;
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 widget.deviceId == null ? "Yeni Cihaz Ekle" : "Cihazı Güncelle",
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: "Cihaz Adı",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _modelController,
//                 decoration: InputDecoration(
//                   labelText: "Model",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _serialController,
//                 decoration: InputDecoration(
//                   labelText: "Seri Numarası",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _locationController,
//                 decoration: InputDecoration(
//                   labelText: "Konum",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text("İptal"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_nameController.text.trim().isNotEmpty &&
//                           _modelController.text.trim().isNotEmpty &&
//                           _serialController.text.trim().isNotEmpty &&
//                           _locationController.text.trim().isNotEmpty) {
//                         widget.onSubmit(
//                           _nameController.text.trim(),
//                           _modelController.text.trim(),
//                           _serialController.text.trim(),
//                           _locationController.text.trim(),
//                         );
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(widget.deviceId == null ? "Ekle" : "Güncelle"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DeviceFormWidget extends StatefulWidget {
  final String? deviceId;
  final String? name;
  final String? model;
  final String? serial;
  final String? location;
  final Function(String, String, String, String) onSubmit;

  DeviceFormWidget({
    this.deviceId,
    this.name,
    this.model,
    this.serial,
    this.location,
    required this.onSubmit,
  });

  @override
  _DeviceFormWidgetState createState() => _DeviceFormWidgetState();
}

class _DeviceFormWidgetState extends State<DeviceFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameController.text = widget.name!;
    if (widget.model != null) _modelController.text = widget.model!;
    if (widget.serial != null) _serialController.text = widget.serial!;
    if (widget.location != null) _locationController.text = widget.location!;
  }

  void _scanQRCode() async {
    final scannedSerial = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );

    if (scannedSerial != null) {
      setState(() {
        _serialController.text = scannedSerial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.deviceId == null ? "Yeni Cihaz Ekle" : "Cihazı Güncelle",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Cihaz Adı",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: "Model",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _serialController,
                      decoration: InputDecoration(
                        labelText: "Seri Numarası",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner, size: 30),
                    onPressed: _scanQRCode,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Konum",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("İptal"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty &&
                          _modelController.text.trim().isNotEmpty &&
                          _serialController.text.trim().isNotEmpty &&
                          _locationController.text.trim().isNotEmpty) {
                        widget.onSubmit(
                          _nameController.text.trim(),
                          _modelController.text.trim(),
                          _serialController.text.trim(),
                          _locationController.text.trim(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.deviceId == null ? "Ekle" : "Güncelle"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================== [ QR KOD TARAMA EKRANI ] ===================
class QRScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Kod Tarayıcı")),
      body: MobileScanner(
       onDetect: (barcodeCapture) {
        final barcode = barcodeCapture.barcodes.first;
        if (barcode.rawValue != null) {
          Navigator.pop(context, barcode.rawValue);
        }
       },
      ),
    );
  }
}

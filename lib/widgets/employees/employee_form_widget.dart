import 'package:flutter/material.dart';

class EmployeeFormWidget extends StatefulWidget {
  final String? employeeId; // Güncelleme için ID
  final String? name;
  final String? position;
  final String? email;
  final String? phone;
  final Function(String, String, String, String) onSubmit;

  EmployeeFormWidget({
    this.employeeId,
    this.name,
    this.position,
    this.email,
    this.phone,
    required this.onSubmit,
  });

  @override
  _EmployeeFormWidgetState createState() => _EmployeeFormWidgetState();
}

class _EmployeeFormWidgetState extends State<EmployeeFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameController.text = widget.name!;
    if (widget.position != null) _positionController.text = widget.position!;
    if (widget.email != null) _emailController.text = widget.email!;
    if (widget.phone != null) _phoneController.text = widget.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(  // Kaydırılabilir hale getirildi
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.employeeId == null ? "Yeni Çalışan Ekle" : "Çalışanı Güncelle",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),  // headline6 yerine titleLarge kullanıldı
              ),
              SizedBox(height: 16),
              // Ad Soyad Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Ad Soyad",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16), // Aradaki boşluğu artırdık
              // Pozisyon Input
              TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: "Pozisyon",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16), // Aradaki boşluğu artırdık
              // E-Posta Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-Posta",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16), // Aradaki boşluğu artırdık
              // Telefon Input
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Telefon",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20), // Aradaki boşluğu artırdık
              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // İptal Butonu
                  TextButton(
                    onPressed: () => Navigator.pop(context),  
                    child: Text("İptal"),
                  ),
                  // Ekle veya Güncelle Butonu
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty &&
                          _positionController.text.trim().isNotEmpty &&
                          _emailController.text.trim().isNotEmpty &&
                          _phoneController.text.trim().isNotEmpty) {
                        widget.onSubmit(
                          _nameController.text.trim(),
                          _positionController.text.trim(),
                          _emailController.text.trim(),
                          _phoneController.text.trim(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor), 
                    child: Text(widget.employeeId == null ? "Ekle" : "Güncelle"),
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

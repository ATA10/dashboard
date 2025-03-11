// event_input_panel.dart

import 'package:flutter/material.dart';

class EventInputPanel extends StatefulWidget {
  final Function(String, String, DateTime, DateTime) onEventAdded;

  EventInputPanel({required this.onEventAdded});

  @override
  _EventInputPanelState createState() => _EventInputPanelState();
}

class _EventInputPanelState extends State<EventInputPanel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startDateTime;
  late DateTime _endDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateTime = DateTime.now();
    _endDateTime = DateTime.now().add(Duration(hours: 1)); // Default 1 hour duration
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Etkinlik Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Başlık'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık girmeniz gerekiyor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Açıklama girmeniz gerekiyor';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text("Başlangıç Zamanı"),
                subtitle: Text("${_startDateTime.toLocal()}"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _startDateTime) {
                    setState(() {
                      _startDateTime = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text("Bitiş Zamanı"),
                subtitle: Text("${_endDateTime.toLocal()}"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _endDateTime) {
                    setState(() {
                      _endDateTime = pickedDate;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onEventAdded(
                      _titleController.text,
                      _descriptionController.text,
                      _startDateTime,
                      _endDateTime,
                    );
                    Navigator.pop(context); // Sayfayı kapat
                  }
                },
                child: Text("Etkinlik Ekle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

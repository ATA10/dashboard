import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'calendar/calender_input_panel.dart';

class FullScreenCalendar extends StatefulWidget {
  final List<CalendarEventData> events;

  FullScreenCalendar({required this.events});

  @override
  _FullScreenCalendarState createState() => _FullScreenCalendarState();
}

class _FullScreenCalendarState extends State<FullScreenCalendar> {
  late EventController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _eventController.addAll(widget.events);
  }

  void _addNewEvent(String title, String description, DateTime start, DateTime end) {
    setState(() {
      widget.events.add(CalendarEventData(
        date: start,
        title: title,
        description: description,
        startTime: start,
        endTime: end,
      ));
      _eventController.add(widget.events.last);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tam Ekran Takvim")),
      body: MonthView(controller: _eventController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Etkinlik ekleme panelini aç
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventInputPanel(onEventAdded: _addNewEvent),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

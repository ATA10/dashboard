// import 'package:flutter/material.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'full_screen_calendar.dart';
// import '../../styles/calendar_style.dart';

// DateTime get _now => DateTime.now();

// List<CalendarEventData> _events = [
//   CalendarEventData(
//     date: _now,
//     title: "Project meeting",
//     description: "Today is project meeting.",
//     startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
//     endTime: DateTime(_now.year, _now.month, _now.day, 22),
//   ),
//   CalendarEventData(
//     date: _now.subtract(Duration(days: 3)),
//     recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
//       startDate: _now.subtract(Duration(days: 3)),
//     ),
//     title: 'Leetcode Contest',
//     description: 'Give leetcode contest',
//   ),
//   // Diğer etkinlikler burada...
// ];

// class CalendarCardWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Tam ekran takvim açılır
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => FullScreenCalendar(events: _events)),
//         );
//       },
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 200, // Küçük önizleme boyutu
//                 color: Colors.blueGrey[100],
//                 child: DayView(
//                   // showLiveTimeLineInAllDays: false,
//                   // showVerticalLine: true,
//                   onEventTap: (events, date) => print(events),
//                   onEventDoubleTap: (events, date) => print(events),
//                   onEventLongTap: (events, date) => print(events),
//                   onDateLongPress: (date) => print(date),
//                   // startHour: 5,
//                   controller: EventController()..addAll(_events),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'full_screen_calendar.dart';
import '../../styles/calendar_style.dart';

DateTime get _now => DateTime.now();

List<CalendarEventData> _events = [
  CalendarEventData(
    date: _now,
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.subtract(const Duration(days: 3)),
    recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
      startDate: _now.subtract(const Duration(days: 3)),
    ),
    title: 'Leetcode Contest',
    description: 'Give leetcode contest',
  ),
  // Diğer etkinlikler burada...
];

class CalendarCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tam ekran takvim açılır
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullScreenCalendar(events: _events)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200, // Küçük önizleme boyutu
                decoration: CalendarStyles.dayViewPreviewDecoration,
                child: DayView(
                  onEventTap: (events, date) => print(events),
                  onEventDoubleTap: (events, date) => print(events),
                  onEventLongTap: (events, date) => print(events),
                  onDateLongPress: (date) => print(date),
                  controller: EventController()..addAll(_events), // Düzeltildi
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


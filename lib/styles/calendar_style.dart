// import 'package:flutter/material.dart';

// class CalendarStyle {
//   // Genel Takvim Görünümü Stilleri
//   static BoxDecoration dayViewBackground = BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(8),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.grey.withOpacity(0.2),
//         spreadRadius: 2,
//         blurRadius: 5,
//         offset: Offset(0, 3),
//       ),
//     ],
//   );

//   static TextStyle dayNumberStyle = TextStyle(
//     fontSize: 8,
//     fontWeight: FontWeight.normal,
//     color: Colors.black87,
//   );

//   static TextStyle weekendDayNumberStyle = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.normal,
//     color: Colors.grey,
//   );

//   static TextStyle todayDayNumberStyle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//   );

//   static BoxDecoration todayDayBackground = BoxDecoration(
//     color: Colors.redAccent,
//     shape: BoxShape.circle,
//   );

//   static TextStyle selectedDayNumberStyle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//   );

//   static BoxDecoration selectedDayBackground = BoxDecoration(
//     color: Colors.blueAccent,
//     shape: BoxShape.circle,
//   );

//   static TextStyle eventTitleStyle = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.bold,
//     color: Colors.blueAccent,
//   );

//   static TextStyle eventDescriptionStyle = TextStyle(
//     fontSize: 10,
//     color: Colors.black54,
//   );

//   static Color eventBackgroundColor = Colors.blueAccent.withOpacity(0.2);

//   static Color eventBorderColor = Colors.blueAccent;

//   static double eventBorderWidth = 1.0;

//   static BorderRadius eventBorderRadius = BorderRadius.circular(5);

//   // Takvim Başlığı Stilleri
//   static TextStyle headerTextStyle = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );

//   static Color headerBackgroundColor = Colors.grey[200]!;

//   // Hafta Günleri Stilleri
//   static TextStyle weekdayTextStyle = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.w500,
//     color: Colors.black54,
//   );

//   static Color weekdayBackgroundColor = Colors.grey[100]!;

//   // Seçili ve Bugün Stilleri
//   static Color selectedDayColor = Colors.blueAccent;
//   static Color todayHighlightColor = Colors.redAccent;

//   // Diğer Stiller
//   static Color outsideDaysColor = Colors.grey[300]!;
//   static Color disabledDaysColor = Colors.grey[400]!;

//   static double cellMargin = 1.0;
//   static double cellPadding = 1.0;
//   static double eventPadding = 1.0;
//   static double eventMargin = 1.0;

//   // Boyutlandırma ve Görünüm Ayarları (Eklenenler)
//   static double cellAspectRatio = 1.0; // Hücrelerin en boy oranı (kare)
//   static double dayViewHeight = 600.0; // DayView yüksekliği
//   static double monthViewWidth = 300.0; // MonthView genişliği (Container ile ayarlanacak)

//   // Hücre Görünümü Özelleştirme (cellBuilder için)
//   static BoxDecoration cellDecoration = BoxDecoration(
//     border: Border.all(color: Colors.grey.withOpacity(0.5)),
//   );

//   static BoxDecoration todayCellDecoration = BoxDecoration(
//     color: Colors.red[100],
//     border: Border.all(color: Colors.grey.withOpacity(0.5)),
//   );
// }



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
//     final eventController = EventController(); // EventController'ı oluşturun
//     eventController.addAll(_events); // Etkinlikleri ekleyin
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
//                 height: CalendarStyle.monthViewWidth, // Küçük önizleme boyutu
//                 color: Colors.blueGrey[100],
//                 child: MonthView(
//                   cellAspectRatio: CalendarStyle.cellAspectRatio,
//                   onEventTap: (events, date) => print(events),
//                   onEventDoubleTap: (events, date) => print(events),
//                   onEventLongTap: (events, date) => print(events),
//                   onDateLongPress: (date) => print(date),
//                   controller: eventController, // EventController'ı atayın
//                   headerStyle: HeaderStyle(
//                     decoration: BoxDecoration(color: CalendarStyle.selectedDayColor),
//                     headerTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   cellBuilder: (date, events, isToday, isSelected, isInMonth) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: isToday ? CalendarStyle.todayHighlightColor : Colors.white,
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(
//                           color: isSelected ? CalendarStyle.selectedDayColor : Colors.grey.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "${date.day}",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isToday ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

////////////////////////////////////////////////////////



import 'package:flutter/material.dart';

class CalendarStyles {
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.lightBlueAccent;
  static const Color backgroundColor = Colors.white;
  static const Color cardBackgroundColor = Colors.white;
  static const Color eventBackgroundColor = Colors.lightBlue;
  static const Color eventTextColor = Colors.white;
  static const MaterialColor dayViewBackgroundColor = Colors.blueGrey;
  static const MaterialColor dayViewPreviewBackgroundColor = Colors.blueGrey;

  static TextStyle eventTitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: eventTextColor,
  );

  static TextStyle eventDescriptionTextStyle = const TextStyle(
    fontSize: 14,
    color: eventTextColor,
  );

  static BoxDecoration eventDecoration = BoxDecoration(
    color: eventBackgroundColor,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static BoxDecoration dayViewPreviewDecoration = BoxDecoration(
    color: dayViewPreviewBackgroundColor[100]!, // Düzeltildi
  );
}
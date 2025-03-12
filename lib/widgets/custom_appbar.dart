import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String title;

//   CustomAppBar({required this.title});

//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   bool _isSettingsOpen = false;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(widget.title),
//       leading: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Image.asset('assets/app_icon.png'), // Uygulama ikonunun yolu
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.settings),
//           onPressed: () {
//             setState(() {
//               _isSettingsOpen = !_isSettingsOpen;
//             });
//           },
//         ),
//         if (_isSettingsOpen)
//           PopupMenuButton<String>(
//             onSelected: (value) async {
//               if (value == 'logout') {
//                 await _auth.signOut();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               } else if (value == 'settings') {
//                 // Ayarlar sayfasına yönlendirme
//               }
//               setState(() {
//                 _isSettingsOpen = false;
//               });
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'settings',
//                 child: Text('Ayarlar'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'logout',
//                 child: Text('Çıkış'),
//               ),
//             ],
//           ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../screens/login_screen.dart';

// class CustomNavigationBar extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   CustomNavigationBar({required this.currentIndex, required this.onTap});

//   @override
//   _CustomNavigationBarState createState() => _CustomNavigationBarState();
// }

// class _CustomNavigationBarState extends State<CustomNavigationBar>
//     with SingleTickerProviderStateMixin {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late Animation<double> _iconRotation;
//   late Animation<double> _iconScale; // İkon boyutunu kontrol eden animasyon

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _iconScale = Tween<double>(begin: 1, end: 1.2).animate( // İkon boyutunu küçültme
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleExpanded() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedBuilder(
//               animation: _iconRotation,
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: _iconRotation.value * 3.14,
//                   child: Transform.scale( // İkon boyutunu değiştir
//                     scale: _iconScale.value,
//                     child: GestureDetector(
//                       onTap: _toggleExpanded,
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.blue,
//                         ),
//                         child: Icon(
//                           _isExpanded ? Icons.close : Icons.menu,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     width: _animation.value * 250,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: _isExpanded
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Opacity(
//                                 opacity: _animation.value,
//                                 child: IconButton(
//                                   icon: Icon(Icons.home),
//                                   onPressed: () => widget.onTap(0),
//                                 ),
//                               ),
//                               Opacity(
//                                 opacity: _animation.value,
//                                 child: IconButton(
//                                   icon: Icon(Icons.settings),
//                                   onPressed: () => widget.onTap(1),
//                                 ),
//                               ),
//                               Opacity(
//                                 opacity: _animation.value,
//                                 child: IconButton(
//                                   icon: Icon(Icons.logout),
//                                   onPressed: () {
//                                     _auth.signOut();
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => LoginScreen(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           )
//                         : null,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _iconRotation;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _iconScale = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _iconRotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _iconRotation.value * 3.14,
                        child: Transform.scale(
                          scale: _iconScale.value,
                          child: GestureDetector(
                            onTap: _toggleExpanded,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: Icon(
                                _isExpanded ? Icons.close : Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: _animation.value * 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200]?.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: _isExpanded
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Opacity(
                                    opacity: _animation.value,
                                    child: IconButton(
                                      icon: Icon(Icons.home, color: Colors.black),
                                      onPressed: () => widget.onTap(0),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _animation.value,
                                    child: IconButton(
                                      icon: Icon(Icons.settings, color: Colors.black),
                                      onPressed: () => widget.onTap(1),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _animation.value,
                                    child: IconButton(
                                      icon: Icon(Icons.logout, color: Colors.black),
                                      onPressed: () {
                                        _auth.signOut();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

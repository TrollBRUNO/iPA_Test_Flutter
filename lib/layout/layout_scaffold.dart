// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    Key? key,
    required this.navigationShell,
    required this.body,
  }) : super(key: key ?? const ValueKey('LayoutScaffold'));

  final Widget body;

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    extendBody: true,
    //backgroundColor: Colors.transparent,
    bottomNavigationBar: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // эффект блюра
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              24,
              24,
              24,
            ).withOpacity(0.6), // стеклянный эффект
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor:
                Colors.orangeAccent[200], //Colors.lightBlueAccent,
            selectedFontSize: 20,
            selectedLabelStyle: GoogleFonts.jura(fontWeight: FontWeight.w900),
            unselectedItemColor: const Color.fromARGB(
              255,
              255,
              209,
              128,
            ).withOpacity(0.5),
            unselectedFontSize: 18,
            unselectedLabelStyle: GoogleFonts.jura(fontWeight: FontWeight.w700),
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              if (index != navigationShell.currentIndex) {
                navigationShell.goBranch(index, initialLocation: true);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library, size: 50),
                label: 'Photo',
                activeIcon: Icon(Icons.photo_library_outlined, size: 60),
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.local_atm, size: 50),
                label: 'Jackpot',
                activeIcon: Icon(Icons.local_atm, size: 60),
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.casino, size: 50),
                label: 'Wheel',
                activeIcon: Icon(Icons.casino_outlined, size: 60),
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.account_box, size: 50),
                label: 'Profile',
                activeIcon: Icon(Icons.account_box_outlined, size: 60),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:first_app_flutter/utils/adaptive_sizes.dart';
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
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);
    return Scaffold(
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
                top: BorderSide(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedItemColor:
                  Colors.orangeAccent[200], //Colors.lightBlueAccent,
              selectedFontSize: AdaptiveSizes.getSelectedFontSize(),
              selectedLabelStyle: GoogleFonts.jura(fontWeight: FontWeight.w900),
              unselectedItemColor: const Color.fromARGB(
                255,
                255,
                209,
                128,
              ).withOpacity(0.5),
              unselectedFontSize: AdaptiveSizes.getUnselectedFontSize(),
              unselectedLabelStyle: GoogleFonts.jura(
                fontWeight: FontWeight.w700,
              ),
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                if (index != navigationShell.currentIndex) {
                  navigationShell.goBranch(index, initialLocation: true);
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library, size: AdaptiveSizes.w(0.075)),
                  label: 'Photo',
                  activeIcon: Icon(
                    Icons.photo_library_outlined,
                    size: AdaptiveSizes.w(0.085),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.local_atm, size: AdaptiveSizes.w(0.075)),
                  label: 'Jackpot',
                  activeIcon: Icon(
                    Icons.local_atm,
                    size: AdaptiveSizes.w(0.085),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.casino, size: AdaptiveSizes.w(0.075)),
                  label: 'Wheel',
                  activeIcon: Icon(
                    Icons.casino_outlined,
                    size: AdaptiveSizes.w(0.085),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.local_play, size: AdaptiveSizes.w(0.075)),
                  label: 'Games',
                  activeIcon: Icon(
                    Icons.local_play_outlined,
                    size: AdaptiveSizes.w(0.085),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box, size: AdaptiveSizes.w(0.075)),
                  label: 'Profile',
                  activeIcon: Icon(
                    Icons.account_box_outlined,
                    size: AdaptiveSizes.w(0.085),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

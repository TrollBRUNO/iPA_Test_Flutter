import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class AdaptiveSizes {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double w(double width) => width * screenWidth;
  static double h(double height) => height * screenHeight;

  static double getUniversalTitleSize() {
    if (screenWidth > 600) return 84;
    if (screenWidth > 400) return 54;
    return 42;
  }

  static double getWheelTitleSize() {
    if (screenWidth > 600) return 90;
    if (screenWidth > 400) return 60;
    return 40;
  }

  static void printSizes() {
    Logger logger = Logger();
    logger.i('Screen Width: $screenWidth');
    logger.i('Screen Height: $screenHeight');
  }

  static double getInputFieldWidth() {
    if (screenWidth > 600) return 450;
    if (screenWidth > 400) return 400;
    return screenWidth * 0.85;
  }

  static EdgeInsets getMainPadding() {
    if (screenWidth > 600) return const EdgeInsets.symmetric(horizontal: 30);
    if (screenWidth > 400) return const EdgeInsets.symmetric(horizontal: 40);
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static EdgeInsets getLeftPrizePadding() {
    if (screenWidth > 600) return const EdgeInsets.only(left: 12);
    if (screenWidth > 400) return const EdgeInsets.only(left: 6);
    return const EdgeInsets.only(left: 4);
  }

  static EdgeInsets getProfileSettinsPadding() {
    if (screenWidth > 600) return const EdgeInsets.all(24);
    if (screenWidth > 400) return const EdgeInsets.all(12);
    return const EdgeInsets.all(12);
  }

  static double getButtonWidth() {
    if (screenWidth > 600) return 350;
    if (screenWidth > 400) return 250;
    return screenWidth * 0.5;
  }

  static double getButtonHeight() {
    if (screenWidth > 600) return 60;
    if (screenWidth > 400) return 50;
    return screenWidth * 0.12;
  }

  static double getIconProfileSize() {
    if (screenWidth > 600) return 120;
    if (screenWidth > 400) return 75;
    return 70;
  }

  static double getLogoSize() {
    if (screenWidth > 600) return 80;
    if (screenWidth > 400) return 60;
    return 60;
  }

  static double getMinVerticalPadding() {
    if (screenWidth > 600) return 16;
    if (screenWidth > 400) return 12;
    return 12;
  }

  static double getIconSettingsSize() {
    if (screenWidth > 600) return 48;
    if (screenWidth > 400) return 38;
    return 38;
  }

  static double getFontSettingsSize() {
    if (screenWidth > 600) return 40;
    if (screenWidth > 400) return 24;
    return 24;
  }

  static double getFontUsernameSize() {
    if (screenWidth > 600) return 36;
    if (screenWidth > 400) return 26;
    return 26;
  }

  static double getIconBackSettingsSize() {
    if (screenWidth > 600) return 30;
    if (screenWidth > 400) return 20;
    return 20;
  }

  static double getFontProfileSize() {
    if (screenWidth > 600) return 28;
    if (screenWidth > 400) return 18;
    return 18;
  }

  static double getFontPrizeSize() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 14;
    return 14;
  }

  static double getFontLanguageSize() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 18;
    return 18;
  }

  static double getFontBigPrizeSize() {
    if (screenWidth > 600) return 32;
    if (screenWidth > 400) return 22;
    return 22;
  }

  static double getSelectedFontSize() {
    if (screenWidth > 600) return 20;
    if (screenWidth > 400) return 16;
    return screenWidth * 0.028;
  }

  static double getUnselectedFontSize() {
    if (screenWidth > 600) return 18;
    if (screenWidth > 400) return 14;
    return screenWidth * 0.028;
  }

  static TextStyle getInputTextStyle() {
    if (screenWidth > 600) {
      return const TextStyle(fontSize: 24, color: Colors.white70);
    }
    if (screenWidth > 400) {
      return const TextStyle(fontSize: 20, color: Colors.white70);
    }
    return const TextStyle(fontSize: 18, color: Colors.white70);
  }

  static TextStyle getLabelStyle() {
    if (screenWidth > 600) {
      return const TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: Colors.white54,
      );
    }
    if (screenWidth > 400) {
      return const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: Colors.white54,
      );
    }
    return const TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: Colors.white54,
    );
  }

  static TextStyle getLabelLinkStyle() {
    if (screenWidth > 600) {
      return const TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: Colors.white54,
        decoration: TextDecoration.underline,
      );
    }
    if (screenWidth > 400) {
      return const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: Colors.white54,
        decoration: TextDecoration.underline,
      );
    }
    return const TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: Colors.white54,
      decoration: TextDecoration.underline,
    );
  }
}

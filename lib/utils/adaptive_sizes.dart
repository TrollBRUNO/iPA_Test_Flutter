import 'package:first_app_flutter/class/jackpot.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (screenWidth > 400) return 50;
    return 40;
  }

  static double getLanguageMinusTitle() {
    if (screenWidth > 600) return 2;
    if (screenWidth > 400) return 4;
    return 4;
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

  static double getCameraWidgetHeight() {
    if (screenWidth > 600) return screenHeight * 0.24358;
    if (screenWidth > 400) return screenHeight * 0.28846;
    return screenHeight * 0.28846;
  }

  static double getStatisticsDialogMaxWidth() {
    if (screenWidth > 600) return 600;
    if (screenWidth > 400) return screenWidth * 0.85648;
    return screenWidth * 0.85648;
  }

  static double getInfoDialogMaxWidth() {
    if (screenWidth > 600) return screenWidth * 0.66667;
    if (screenWidth > 400) return screenWidth * 0.88889;
    return screenWidth * 0.88889;
  }

  static double getAdsDialogMaxWidth() {
    if (screenWidth > 600) return screenWidth * 0.90277;
    if (screenWidth > 400) return screenWidth * 0.86555;
    return screenWidth * 0.85763;
  }

  static double getPrizeDialogMaxWidth() {
    if (screenWidth > 600) return screenWidth * 0.83333;
    if (screenWidth > 400) return screenWidth * 0.91666;
    return screenWidth * 0.91666;
  }

  static double getPrizeDialogMinWidth() {
    if (screenWidth > 600) return screenWidth * 0.66667;
    if (screenWidth > 400) return screenWidth * 0.83334;
    return screenWidth * 0.83334;
  }

  static double getSettingsLanguageHeight() {
    if (screenWidth > 600) return 100;
    if (screenWidth > 400) return 80;
    return 80;
  }

  static double getPrizeDialogMaxHeight() {
    if (screenWidth > 600) return screenHeight * 0.32051;
    if (screenWidth > 400) return screenHeight * 0.42269;
    return screenHeight * 0.42269;
  }

  static double getPrizeDialogMinHeight() {
    if (screenWidth > 600) return screenHeight * 0.20513;
    if (screenWidth > 400) return screenHeight * 0.3077;
    return screenHeight * 0.3077;
  }

  static double getStatisticsDialogMinHeight() {
    if (screenWidth > 600) return 320;
    if (screenWidth > 400) return screenWidth * 0.4444;
    return screenWidth * 0.4444;
  }

  static double getNewsTabSecondHeight() {
    if (screenWidth > 600) return screenHeight * 0.03077;
    if (screenWidth > 400) return screenHeight * 0.06254;
    return screenWidth * 0.04616;
  }

  static double getNewsTabHeight() {
    if (screenWidth > 600) return screenHeight * 0.11218;
    if (screenWidth > 400) return screenHeight * 0.19631;
    return screenWidth * 0.19631;
  }

  static double getNewsTabContainerHeight() {
    if (screenWidth > 600) return screenHeight * 0.0565;
    if (screenWidth > 400) return screenHeight * 0.07813;
    return screenWidth * 0.07813;
  }

  static double getJackpotWidgetHeight() {
    if (screenWidth > 600) return screenHeight * 0.19872;
    if (screenWidth > 400) return screenHeight * 0.2782;
    return screenWidth * 0.2782;
  }

  static double getStatisticsDialogMaxHeight() {
    if (screenWidth > 600) return 900;
    if (screenWidth > 400) return screenWidth * 1.25;
    return screenWidth * 1.25;
  }

  static BorderRadius getJackpotWidgetBorderRadius() {
    if (screenWidth > 600) return BorderRadius.circular(20);
    if (screenWidth > 400) return BorderRadius.circular(16);
    return BorderRadius.circular(16);
  }

  static BorderRadius getLiveJackpotWidgetBorderRadius() {
    if (screenWidth > 600) return BorderRadius.circular(12);
    if (screenWidth > 400) return BorderRadius.circular(10);
    return BorderRadius.circular(10);
  }

  static BorderRadius getJackpotWidgetBorderSecondRadius() {
    if (screenWidth > 600) return BorderRadius.circular(36);
    if (screenWidth > 400) return BorderRadius.circular(28);
    return BorderRadius.circular(28);
  }

  static BorderRadius getAdsDialogRadius() {
    if (screenWidth > 600) return BorderRadius.circular(40);
    if (screenWidth > 400) return BorderRadius.circular(24);
    return BorderRadius.circular(24);
  }

  static EdgeInsets getMainPadding() {
    if (screenWidth > 600) return const EdgeInsets.symmetric(horizontal: 30);
    if (screenWidth > 400) return const EdgeInsets.symmetric(horizontal: 40);
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static EdgeInsets getCameraWidgetInfoPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
    if (screenWidth > 400)
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
    return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
  }

  static EdgeInsets getLeftPrizePadding() {
    if (screenWidth > 600) return const EdgeInsets.only(left: 12);
    if (screenWidth > 400) return const EdgeInsets.only(left: 6);
    return const EdgeInsets.only(left: 4);
  }

  static EdgeInsets getAdsPadding() {
    if (screenWidth > 600) return const EdgeInsets.all(28);
    if (screenWidth > 400) return const EdgeInsets.all(16);
    return const EdgeInsets.all(16);
  }

  static EdgeInsets getProfileSettinsPadding() {
    if (screenWidth > 600) return const EdgeInsets.all(24);
    if (screenWidth > 400) return const EdgeInsets.all(12);
    return const EdgeInsets.all(12);
  }

  static EdgeInsets getSettingsRowPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(vertical: 6, horizontal: 32);
    if (screenWidth > 400)
      const EdgeInsets.symmetric(vertical: 4, horizontal: 12);
    return const EdgeInsets.symmetric(vertical: 4, horizontal: 12);
  }

  static EdgeInsets getStatisticsRowPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(vertical: 4, horizontal: 24);
    if (screenWidth > 400) const EdgeInsets.symmetric(vertical: 4);
    return const EdgeInsets.symmetric(vertical: 4);
  }

  static EdgeInsets getJackpotWidgetRowPadding() {
    if (screenWidth > 600) return const EdgeInsets.symmetric(vertical: 6);
    if (screenWidth > 400) const EdgeInsets.symmetric(vertical: 3);
    return const EdgeInsets.symmetric(vertical: 3);
  }

  static EdgeInsets getJackpotWidgetPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    if (screenWidth > 400)
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    return const EdgeInsets.symmetric(horizontal: 8, vertical: 5);
  }

  static EdgeInsets getJackpotContentWidgetSecondPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 6);
    if (screenWidth > 400)
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
    return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
  }

  static EdgeInsets getJackpotContentWidgetThirdPadding(
    bool isMysteryProgressive,
  ) {
    if (isMysteryProgressive) {
      if (screenWidth > 600) return const EdgeInsets.symmetric(horizontal: 16);
      if (screenWidth > 400) const EdgeInsets.symmetric(horizontal: 10);
      return const EdgeInsets.symmetric(horizontal: 10);
    } else {
      if (screenWidth > 600)
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      if (screenWidth > 400)
        const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
    }
  }

  static EdgeInsets getJackpotContentWidgetPadding() {
    if (screenWidth > 600) return const EdgeInsets.fromLTRB(24, 16, 24, 16);
    if (screenWidth > 400) const EdgeInsets.fromLTRB(12, 8, 12, 8);
    return const EdgeInsets.fromLTRB(12, 8, 12, 8);
  }

  static double getButtonHeight() {
    if (screenWidth > 600) return 60;
    if (screenWidth > 400) return 50;
    return screenWidth * 0.12;
  }

  static double getButtonWidth() {
    if (screenWidth > 600) return 350;
    if (screenWidth > 400) return 250;
    return screenWidth * 0.5;
  }

  static double getJackpotPercentSize() {
    if (screenWidth > 600) return 180;
    if (screenWidth > 400) return screenWidth * 0.27777;
    return screenWidth * 0.27777;
  }

  static double getJackpotLogoFontSecondSize() {
    if (screenWidth > 600) return 62;
    if (screenWidth > 400) return screenWidth * 0.11388;
    return screenWidth * 0.1;
  }

  static double getWheelSizedBoxlanguageCode() {
    if (screenWidth > 600) return 100;
    if (screenWidth > 400) return 20;
    return 10;
  }

  static double getJackpotLogoFontSize() {
    if (screenWidth > 600) return 32;
    if (screenWidth > 400) return screenWidth * 0.04444;
    return screenWidth * 0.04444;
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

  static double getLogoPrizeSize() {
    if (screenWidth > 600) return 80;
    if (screenWidth > 400) return 50;
    return 50;
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

  static double getFontStatisticsIconSize() {
    if (screenWidth > 600) return 36;
    if (screenWidth > 400) return 20;
    return 20;
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

  static double getJackpotCountSize() {
    if (screenWidth > 600) return 26;
    if (screenWidth > 400) return 20;
    return 20;
  }

  static double getBigWinYouWinPrizeSize() {
    if (screenWidth > 600) return 52;
    if (screenWidth > 400) return 32;
    return 32;
  }

  static double getYouWinPrizeSize() {
    if (screenWidth > 600) return 28;
    if (screenWidth > 400) return 18;
    return 18;
  }

  static double getFontBalanceSize() {
    if (screenWidth > 600) return 28;
    if (screenWidth > 400) return 18;
    return 18;
  }

  ///
  static double getFontNewsTitleSize() {
    if (screenWidth > 600) return 58;
    if (screenWidth > 400) return 32;
    return 32;
  }

  static double getFontNewsTitleSecondSize() {
    if (screenWidth > 600) return 72;
    if (screenWidth > 400) return 42;
    return 42;
  }

  ///
  static double getFontProfileSize() {
    if (screenWidth > 600) return 28;
    if (screenWidth > 400) return 24;
    return 24;
  }

  static double getFancyButtonTextSize() {
    if (screenWidth > 600) return 38;
    if (screenWidth > 400) return 28;
    return 28;
  }

  static double getFontPrizeSize() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 14;
    return 14;
  }

  static double getFontInfoSize() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 18;
    return 18;
  }

  static double getAddressSize() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 18;
    return 18;
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

  static double getBigWinFontSize() {
    if (screenWidth > 600) return 64;
    if (screenWidth > 400) return 44;
    return 44;
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

  static double getRangeJackpotSize() {
    if (screenWidth > 600) return 21;
    if (screenWidth > 400) return 11;
    return 11;
  }

  static double getLikeSafeAreaJackpotPadding() {
    if (screenWidth > 600) return 24;
    if (screenWidth > 400) return 8;
    return 8;
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

  static TextStyle getCityJackpotTextStyle() {
    if (screenWidth > 600) {
      return const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    if (screenWidth > 400) {
      return const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    return const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle getLiveJackpotTextStyle() {
    if (screenWidth > 600) {
      return const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    if (screenWidth > 400) {
      return const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
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

  static TextStyle getCityJackpotDetailTextStyle() {
    if (screenWidth > 600) {
      return GoogleFonts.daysOne(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    if (screenWidth > 400) {
      return GoogleFonts.daysOne(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
    return GoogleFonts.daysOne(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}

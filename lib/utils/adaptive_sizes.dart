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

  static double getProfileTitleSize(String language) {
    if (screenWidth > 600) {
      if (language == "bg") return screenWidth * 0.10556;
      if (language == "ru") return screenWidth * 0.11111;
      return screenWidth * 0.11667;
    }
    if (screenWidth > 400) {
      if (language == "bg") return screenWidth * 0.1;
      if (language == "ru") return screenWidth * 0.11574;
      return screenWidth * 0.125;
    }

    if (screenHeight > 1000 && screenWidth < 450) {
      if (language == "bg") return screenWidth * 0.1;
      if (language == "ru") return screenWidth * 0.11574;
      return screenWidth * 0.135;
    }

    return screenWidth * 0.135;
  }

  static double getUniversalTitleSize() {
    if (screenWidth > 600) return screenWidth * 0.11667;
    if (screenWidth > 400) return screenWidth * 0.125;
    if (screenHeight > 1000 && screenWidth < 450) return screenWidth * 0.135;
    return screenWidth * 0.125;
  }

  static double getWheelTitleSize() {
    if (screenWidth > 600) return screenWidth * 0.125;
    if (screenWidth > 400) return screenWidth * 0.11574;
    if (screenHeight > 1000 && screenWidth < 450) return screenWidth * 0.125;
    return screenWidth * 0.11574;
  }

  static double getLanguageMinusTitle() {
    if (screenWidth > 600) return screenWidth * 0.00278;
    if (screenWidth > 400) return screenWidth * 0.009;
    return screenWidth * 0.009;
  }

  static void printSizes() {
    Logger logger = Logger();
    logger.i('Screen Width: $screenWidth');
    logger.i('Screen Height: $screenHeight');
  }

  static double getInputFieldHeight() {
    if (screenWidth > 600) return 150;
    if (screenWidth > 400) return 100;
    return screenWidth * 0.1;
  }

  static double getInputFieldWidth() {
    if (screenWidth > 600) return 580;
    if (screenWidth > 400) return 400;
    return screenWidth * 0.85;
  }

  static double getCameraWidgetHeight() {
    if (screenWidth > 600) return screenWidth * 0.52778;
    if (screenWidth > 400) return screenWidth * 0.50926;
    return screenWidth * 0.50926;
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
    if (screenWidth > 600) return screenWidth * 0.69444;
    if (screenWidth > 400) return screenWidth * 0.75232;
    return screenWidth * 0.75232;
  }

  static double getPrizeDialogMinHeight() {
    if (screenWidth > 600) return screenWidth * 0.44444;
    if (screenWidth > 400) return screenWidth * 0.5463;
    if (screenHeight > 1000 && screenWidth < 450) return screenWidth * 0.59;
    return screenWidth * 0.5463;
  }

  static double getStatisticsDialogMinHeight() {
    if (screenWidth > 600) return 320;
    if (screenWidth > 400) return screenWidth * 0.4444;
    return screenWidth * 0.4444;
  }

  static double getNewsTabSecondHeight() {
    if (screenWidth > 600) return screenHeight * 0.03077;
    if (screenWidth > 400) return screenHeight * 0.06254;
    return screenHeight * 0.06254;
  }

  static double getVisibleTitleNewsHeight() {
    if (screenHeight > 1200) return screenHeight * 0.12821;
    if (screenHeight > 700) return screenHeight * 0.15625;
    return screenHeight * 0.15625;
  }

  static double getNewsWidgetHeight() {
    if (screenWidth > 600) return screenHeight * 0.28013;
    if (screenWidth > 400) return screenHeight * 0.32552;
    return screenHeight * 0.32552;
  }

  static double getNewsTabHeight() {
    if (screenHeight > 1200) return screenHeight * 0.11218;
    if (screenHeight > 700) return screenHeight * 0.19631;
    return screenHeight * 0.19631;
  }

  static double getNewsTabContainerHeight() {
    if (screenWidth > 600) return screenHeight * 0.0565;
    if (screenWidth > 400) return screenHeight * 0.07813;
    return screenHeight * 0.07813;
  }

  static double getJackpotWidgetHeight() {
    if (screenWidth > 600) return screenHeight * 0.19872;
    if (screenWidth > 400) return screenHeight * 0.2782;
    return screenHeight * 0.2782;
  }

  static double getStatisticsDialogMaxHeight() {
    if (screenWidth > 600) return 900;
    if (screenWidth > 400) return screenWidth * 1.25;
    return screenWidth * 1.25;
  }

  static double getDividerProfileHeight() {
    if (screenHeight > 1000) return screenHeight * 0.0153;
    return screenHeight * 0.01042;
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

  static EdgeInsets getWidgetNewsPadding() {
    if (screenWidth > 600)
      return EdgeInsets.only(top: (screenHeight * 0.25641), bottom: 40);
    if (screenWidth > 400)
      return EdgeInsets.only(top: (screenHeight * 0.27995), bottom: 40);
    return EdgeInsets.only(top: (screenHeight * 0.27995), bottom: 40);
  }

  static EdgeInsets getAdsPadding() {
    if (screenWidth > 600) return const EdgeInsets.all(28);
    if (screenWidth > 400) return const EdgeInsets.all(16);
    return const EdgeInsets.all(16);
  }

  static EdgeInsets getProfileSettingsPadding() {
    if (screenWidth > 600)
      return const EdgeInsets.symmetric(vertical: 24, horizontal: 24);
    if (screenWidth > 400)
      return const EdgeInsets.symmetric(vertical: 8, horizontal: 8);
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 8);
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

  static double getTitleNewsHeight() {
    if (screenWidth > 600) return screenHeight * 0.05128;
    if (screenWidth > 400) return screenHeight * 0.08463;
    return screenHeight * 0.08463;
  }

  static double getButtonWidth() {
    if (screenWidth > 600) return screenWidth * 0.41667;
    if (screenWidth > 400) return screenWidth * 0.5;
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
    if (screenWidth > 600) return screenHeight * 0.06410;
    if (screenWidth > 400) return screenHeight * 0.05208;
    return screenHeight * 0.05208;
  }

  static double getJackpotLogoFontSize2() {
    if (screenWidth > 600) return screenWidth * 0.04444;
    if (screenWidth > 400) return screenWidth * 0.05128;
    if (screenHeight > 1000 && screenWidth < 450) return screenWidth * 0.04444;
    return screenWidth * 0.05128;
  }

  static double getJackpotLogoFontSize() {
    if (screenWidth > 600) return screenWidth * 0.04444;
    if (screenWidth > 400) return screenWidth * 0.05128;
    return screenWidth * 0.05128;
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

  static double getIconAuthorizationSize() {
    if (screenWidth > 600) return screenWidth * 0.06388;
    if (screenWidth > 400) return screenWidth * 0.06944;
    return screenWidth * 0.06944;
  }

  static double getIconSettingsSize() {
    if (screenWidth > 600) return screenWidth * 0.06667;
    if (screenWidth > 400) return screenWidth * 0.08333;
    return screenWidth * 0.08333;
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
    if (screenWidth > 400) return 34;
    return 34;
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
    if (screenWidth > 600) return screenWidth * 0.02777;
    if (screenWidth > 400) return screenWidth * 0.03704;
    return screenWidth * 0.03704;
  }

  static double getUnselectedFontSize() {
    if (screenWidth > 600) return screenWidth * 0.025;
    if (screenWidth > 400) return screenWidth * 0.03241;
    return screenWidth * 0.03241;
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
      return TextStyle(fontSize: screenWidth * 0.05, color: Colors.white70);
    }
    if (screenWidth > 400) {
      return TextStyle(fontSize: screenWidth * 0.05092, color: Colors.white70);
    }
    return TextStyle(fontSize: screenWidth * 0.05092, color: Colors.white70);
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

  static TextStyle getLabelStyleButton() {
    if (screenWidth > 600) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.05833,
        color: Colors.white,
        wordSpacing: 5.5,
        letterSpacing: 3.5,
      );
    }
    if (screenWidth > 400) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.05833,
        color: Colors.white,
        wordSpacing: 5.5,
        letterSpacing: 3.5,
      );
    }
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.05833,
      color: Colors.white,
      wordSpacing: 5.5,
      letterSpacing: 3.5,
    );
  }

  static TextStyle getLabelStyle() {
    if (screenWidth > 600) {
      return TextStyle(
        fontSize: screenWidth * 0.04167,
        fontWeight: FontWeight.w300,
        color: Colors.white54,
      );
    }
    if (screenWidth > 400) {
      return TextStyle(
        fontSize: screenWidth * 0.04167,
        fontWeight: FontWeight.w300,
        color: Colors.white54,
      );
    }
    return TextStyle(
      fontSize: screenWidth * 0.04167,
      fontWeight: FontWeight.w300,
      color: Colors.white54,
    );
  }

  static TextStyle getLabelLinkStyle() {
    if (screenWidth > 600) {
      return TextStyle(
        fontSize: screenWidth * 0.041667,
        color: Colors.white54,
        decoration: TextDecoration.lineThrough,
      );
    }
    if (screenWidth > 400) {
      return TextStyle(
        fontSize: screenWidth * 0.041667,
        color: Colors.white54,
        decoration: TextDecoration.lineThrough,
      );
    }
    return TextStyle(
      fontSize: screenWidth * 0.041667,
      color: Colors.white54,
      decoration: TextDecoration.lineThrough,
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

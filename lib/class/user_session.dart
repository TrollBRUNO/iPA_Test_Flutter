import 'package:flutter/foundation.dart';

class UserSession {
  static String? username = '';
  static String? balance = '0';
  static String? bonusBalance = '0';
  static String? fakeBalance = '0';
  static DateTime? lastCreditTake = DateTime.now();
  static String? imageUrl = '';

  static ValueNotifier<bool> canShowButton = ValueNotifier<bool>(false);
}

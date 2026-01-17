class UserNotificationSettings {
  bool wheelReady;
  bool bonusReminder;
  bool newsPost;
  bool jackpotWin;

  int mini;
  int middle;
  int mega;

  UserNotificationSettings({
    required this.wheelReady,
    required this.bonusReminder,
    required this.newsPost,
    required this.jackpotWin,
    required this.mini,
    required this.middle,
    required this.mega,
  });

  factory UserNotificationSettings.fromJson(Map<String, dynamic> json) {
    final thresholds = json['jackpot_thresholds'] ?? {};

    return UserNotificationSettings(
      wheelReady: json['wheel_ready'] ?? true,
      bonusReminder: json['bonus_reminder'] ?? true,
      newsPost: json['news_post'] ?? true,
      jackpotWin: json['jackpot_win'] ?? true,

      mini: thresholds['mini'] ?? 100,
      middle: thresholds['middle'] ?? 500,
      mega: thresholds['mega'] ?? 3000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wheel_ready': wheelReady,
      'bonus_reminder': bonusReminder,
      'news_post': newsPost,
      'jackpot_win': jackpotWin,
      'jackpot_thresholds': {'mini': mini, 'middle': middle, 'mega': mega},
    };
  }
}

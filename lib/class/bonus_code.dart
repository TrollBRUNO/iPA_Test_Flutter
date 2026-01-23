class BonusCodeResponse {
  final String code;
  final DateTime expiresAt;
  final DateTime serverTime;

  BonusCodeResponse({
    required this.code,
    required this.expiresAt,
    required this.serverTime,
  });

  factory BonusCodeResponse.fromJson(Map<String, dynamic> json) {
    return BonusCodeResponse(
      code: json['code'],
      expiresAt: DateTime.parse(json['expires_at']),
      serverTime: DateTime.parse(json['server_time']),
    );
  }
}

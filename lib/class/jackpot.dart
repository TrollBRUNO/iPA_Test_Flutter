class Jackpot {
  String city; //= 'Sample City';
  String address; //= 'Main Street 123';
  String imageUrl; //= 'assets/images/logo.png';
  bool isMysteryProgressive; //= true;

  //для MysteryProgressive
  double miniMystery; //= 99.99;
  double middleMystery; //= 555.55;
  double megaMystery; //= 7777.77;

  //для других таблиц
  double majorBellLink; //= 777.77;
  double grandBellLink; //= 9999.99;

  Jackpot({
    this.city = "No name",
    this.address = "No address",
    this.imageUrl = "assets/images/logo.png",
    this.isMysteryProgressive = false,
    this.miniMystery = 0,
    this.middleMystery = 0,
    this.megaMystery = 0,
    this.majorBellLink = 0,
    this.grandBellLink = 0,
  });

  static Jackpot from({required Jackpot jackpot}) {
    return Jackpot(
      city: jackpot.city,
      address: jackpot.address,
      imageUrl: jackpot.imageUrl,
      isMysteryProgressive: jackpot.isMysteryProgressive,
      miniMystery: jackpot.miniMystery,
      middleMystery: jackpot.middleMystery,
      megaMystery: jackpot.megaMystery,
      majorBellLink: jackpot.majorBellLink,
      grandBellLink: jackpot.grandBellLink,
    );
  }

  Jackpot copyWith({
    String? city,
    String? address,
    String? imageUrl,
    bool? isMysteryProgressive,
    double? miniMystery,
    double? middleMystery,
    double? megaMystery,
    double? majorBellLink,
    double? grandBellLink,
  }) {
    return Jackpot(
      city: city ?? this.city,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isMysteryProgressive: isMysteryProgressive ?? this.isMysteryProgressive,
      miniMystery: miniMystery ?? this.miniMystery,
      middleMystery: middleMystery ?? this.middleMystery,
      megaMystery: megaMystery ?? this.megaMystery,
      majorBellLink: majorBellLink ?? this.majorBellLink,
      grandBellLink: grandBellLink ?? this.grandBellLink,
    );
  }
}

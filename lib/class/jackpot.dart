class Jackpot {
  String city; //= 'Sample City';
  String address; //= 'Main Street 123';
  String imageUrl; //= 'assets/images/logo.png';
  bool isMysteryProgressive; //= true;
  String jackpotUrl; //= 'https://example.com/jackpot';

  List<String> uuIdList; //= [];

  //для MysteryProgressive
  double miniMystery; //= 99.99;
  double middleMystery; //= 555.55;
  double megaMystery; //= 7777.77;

  String miniRange; //=  (300 - 800 BGN);
  String middleRange; //= (1200 - 2500 BGN);
  String megaRange; //= (7000 - 10000 BGN);

  //для других таблиц
  double majorBellLink; //= 777.77;
  double grandBellLink; //= 9999.99;

  String majorBellLinkRange; //= (500 - 1500 BGN);
  String grandBellLinkRange; //= (8000 - 20000 BGN);

  Jackpot({
    this.city = "No name",
    this.address = "No address",
    this.imageUrl = "assets/images/logo.png",
    this.isMysteryProgressive = false,
    this.jackpotUrl = "",
    this.uuIdList = const [],
    this.miniMystery = 0,
    this.middleMystery = 0,
    this.megaMystery = 0,
    this.majorBellLink = 0,
    this.grandBellLink = 0,
    this.miniRange = "(0 - 0) EUR",
    this.middleRange = "(0 - 0) EUR",
    this.megaRange = "(0 - 0) EUR",
    this.majorBellLinkRange = "(0 - 0) EUR",
    this.grandBellLinkRange = "(0 - 0) EUR",
  });

  static Jackpot from({required Jackpot jackpot}) {
    return Jackpot(
      city: jackpot.city,
      address: jackpot.address,
      imageUrl: jackpot.imageUrl,
      isMysteryProgressive: jackpot.isMysteryProgressive,
      jackpotUrl: jackpot.jackpotUrl,
      uuIdList: jackpot.uuIdList,
      miniMystery: jackpot.miniMystery,
      middleMystery: jackpot.middleMystery,
      megaMystery: jackpot.megaMystery,
      majorBellLink: jackpot.majorBellLink,
      grandBellLink: jackpot.grandBellLink,
      miniRange: jackpot.miniRange,
      middleRange: jackpot.middleRange,
      megaRange: jackpot.megaRange,
      majorBellLinkRange: jackpot.majorBellLinkRange,
      grandBellLinkRange: jackpot.grandBellLinkRange,
    );
  }

  Jackpot copyWith({
    String? city,
    String? address,
    String? imageUrl,
    bool? isMysteryProgressive,
    String? jackpotUrl,
    List<String>? uuIdList,
    double? miniMystery,
    double? middleMystery,
    double? megaMystery,
    double? majorBellLink,
    double? grandBellLink,
    String? miniRange,
    String? middleRange,
    String? megaRange,
    String? majorBellLinkRange,
    String? grandBellLinkRange,
  }) {
    return Jackpot(
      city: city ?? this.city,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isMysteryProgressive: isMysteryProgressive ?? this.isMysteryProgressive,
      jackpotUrl: jackpotUrl ?? this.jackpotUrl,
      uuIdList: uuIdList ?? this.uuIdList,
      miniMystery: miniMystery ?? this.miniMystery,
      middleMystery: middleMystery ?? this.middleMystery,
      megaMystery: megaMystery ?? this.megaMystery,
      majorBellLink: majorBellLink ?? this.majorBellLink,
      grandBellLink: grandBellLink ?? this.grandBellLink,
      miniRange: miniRange ?? this.miniRange,
      middleRange: middleRange ?? this.middleRange,
      megaRange: megaRange ?? this.megaRange,
      majorBellLinkRange: majorBellLinkRange ?? this.majorBellLinkRange,
      grandBellLinkRange: grandBellLinkRange ?? this.grandBellLinkRange,
    );
  }
}

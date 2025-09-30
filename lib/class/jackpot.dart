class Jackpot {
  final String city; //= 'Sample City';
  final String address; //= 'Main Street 123';
  final String imageUrl; //= 'assets/images/logo.png';
  final bool isMysteryProgressive; //= true;

  //для MysteryProgressive
  final double miniMystery; //= 99.99;
  final double middleMystery; //= 555.55;
  final double megaMystery; //= 7777.77;

  //для других таблиц
  final double majorBellLink; //= 777.77;
  final double grandBellLink; //= 9999.99;

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
}

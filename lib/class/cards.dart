class Cards {
  final String cardId;
  final String city;
  final bool isActive;

  Cards({required this.cardId, required this.city, required this.isActive});

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      cardId: json['card_id'],
      city: json['city'],
      isActive: json['active'],
    );
  }
}

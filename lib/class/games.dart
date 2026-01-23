class Games {
  String name; //= 'Sample City';
  String imageUrl; //= 'assets/images/logo.png';
  String addressUrl; //= 'https://example.com/game';

  Games({
    this.name = "No name",
    this.imageUrl = "assets/images/logo.png",
    this.addressUrl = "https://example.com/game",
  });

  static Games from({required Games games}) {
    return Games(
      name: games.name,
      imageUrl: games.imageUrl,
      addressUrl: games.addressUrl,
    );
  }

  Games copyWith({String? name, String? imageUrl, String? addressUrl}) {
    return Games(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      addressUrl: addressUrl ?? this.addressUrl,
    );
  }
}

class News {
  final String title; //'Sample News Title';
  final String description; //'This is a sample news description.';
  final String imageUrl; //'assets/images/3.jpg';
  final DateTime publicationDate; //DateTime.now();

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publicationDate,
  });
}

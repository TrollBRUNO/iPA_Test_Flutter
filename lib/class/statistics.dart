class Statistics {
  final DateTime publicationDate; //= DateTime.now();
  final int prizeCount; //= '100 BGN';

  Statistics({required this.publicationDate, required this.prizeCount});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      publicationDate: DateTime.parse(json['spin_date']),
      prizeCount: json['prize_count'],
    );
  }
}

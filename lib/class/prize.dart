class Prize {
  final int value;

  const Prize(this.value);

  String get formatted => '$value EUR';

  // Для удобства сравнения призов
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prize &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

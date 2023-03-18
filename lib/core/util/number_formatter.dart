extension NumberFormatter on int {
  String toDollar() {
    final formattedValue = toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return '\$$formattedValue';
  }
}

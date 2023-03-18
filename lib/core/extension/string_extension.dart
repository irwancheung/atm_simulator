extension StringExtension on String {
  String toSentenceCase() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

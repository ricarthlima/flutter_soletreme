String getTodayMazeId() {
  final DateTime startDate = DateTime(2026, 3, 23);

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  final int daysPassed = today.difference(startDate).inDays + 1;

  return daysPassed.toString();
}

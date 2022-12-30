extension DateTimeExtensions on DateTime {
  bool isNotSameDate(DateTime otherDate) {
    return day != otherDate.day ||
        month != otherDate.month ||
        year != otherDate.year;
  }
}

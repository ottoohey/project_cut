extension DoubleExtensions on double {
  double toTwoDecimalPlaces() {
    return double.parse(toStringAsFixed(2));
  }
}

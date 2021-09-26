class PeriodType {

  final String? name;
  final int? milliseconds;

  PeriodType({this.name, this.milliseconds});

}

final List<PeriodType> periods = [
  PeriodType(
    name: "Hour",
    milliseconds: 3.6e+6.toInt(),
  ),
  PeriodType(
    name: "Day",
    milliseconds: 8.64e+7.toInt(),
  ),
  PeriodType(
    name: "Week",
    milliseconds: 6.048e+8.toInt(),
  ),
  PeriodType(
    name: "Month",
    milliseconds: 2.628e+9.toInt(),
  ),
];

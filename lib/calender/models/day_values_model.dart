class DayValues {
  final DateTime day;
  final String text;
  final bool isSelected;
  final bool isFirstDayOfWeek;
  final bool isLastDayOfWeek;
  final DateTime? selectedMinDate;
  final DateTime? selectedMaxDate;
  final DateTime minDate;
  final DateTime maxDate;

  DayValues({
    required this.day,
    required this.text,
    required this.isSelected,
    required this.isFirstDayOfWeek,
    required this.isLastDayOfWeek,
    this.selectedMinDate,
    this.selectedMaxDate,
    required this.minDate,
    required this.maxDate,
  });
}

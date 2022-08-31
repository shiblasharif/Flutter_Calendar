import 'package:calendar/calender/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalCalendarController extends ChangeNotifier {
  final DateTime minDate;
  final DateTime maxDate;
  final bool rangeMode;
  final bool readOnly;
  final int weekdayStart;
  final Function(DateTime date)? onDayTapped;
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;
  final Function(DateTime date)? onPreviousMinDateTapped;
  final Function(DateTime date)? onAfterMaxDateTapped;
  final DateTime? initialDateSelected;
  final DateTime? endDateSelected;
  final DateTime? initialFocusDate;
  late int weekdayEnd;
  List<DateTime> months = [];
  final ItemScrollController itemScrollController = ItemScrollController();

  HorizontalCalendarController({
    required this.minDate,
    required this.maxDate,
    this.rangeMode = true,
    this.readOnly = false,
    this.endDateSelected,
    this.initialDateSelected,
    this.onDayTapped,
    this.onRangeSelected,
    this.onAfterMaxDateTapped,
    this.onPreviousMinDateTapped,
    this.weekdayStart = DateTime.monday,
    this.initialFocusDate,
  })  : assert(weekdayStart <= DateTime.sunday),
        assert(weekdayStart >= DateTime.monday) {
    final x = weekdayStart - 1;
    weekdayEnd = x == 0 ? 7 : x;

    DateTime currentDate = DateTime(minDate.year, minDate.month);
    months.add(currentDate);

    while (!(currentDate.year == maxDate.year &&
        currentDate.month == maxDate.month)) {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
      months.add(currentDate);
    }

    if (initialDateSelected != null &&
        (initialDateSelected!.isAfter(minDate) ||
            initialDateSelected!.isSameDay(minDate))) {
      onDayClick(initialDateSelected!, update: false);
    }

    if (endDateSelected != null &&
        (endDateSelected!.isBefore(maxDate) ||
            endDateSelected!.isSameDay(maxDate))) {
      onDayClick(endDateSelected!, update: false);
    }
  }

  DateTime? rangeMinDate;
  DateTime? rangeMaxDate;

  List<String> getDaysOfWeek([String locale = 'pt']) {
    var today = DateTime.now();

    while (today.weekday != weekdayStart) {
      today = today.subtract(const Duration(days: 1));
    }
    final dateFormat = DateFormat(DateFormat.ABBR_WEEKDAY, locale);
    final daysOfWeek = [
      dateFormat.format(today),
      dateFormat.format(today.add(const Duration(days: 1))),
      dateFormat.format(today.add(const Duration(days: 2))),
      dateFormat.format(today.add(const Duration(days: 3))),
      dateFormat.format(today.add(const Duration(days: 4))),
      dateFormat.format(today.add(const Duration(days: 5))),
      dateFormat.format(today.add(const Duration(days: 6)))
    ];

    return daysOfWeek;
  }

  void onDayClick(DateTime date, {bool update = true}) {
    if (rangeMode) {
      if (rangeMinDate == null || rangeMaxDate != null) {
        rangeMinDate = date;
        rangeMaxDate = null;
      } else if (date.isBefore(rangeMinDate!)) {
        rangeMaxDate = rangeMinDate;
        rangeMinDate = date;
      } else if (date.isAfter(rangeMinDate!) || date.isSameDay(rangeMinDate!)) {
        rangeMaxDate = date;
      }
    } else {
      rangeMinDate = date;
      rangeMaxDate = date;
    }

    if (update) {
      notifyListeners();

      if (onDayTapped != null) {
        onDayTapped!(date);
      }

      if (onRangeSelected != null) {
        onRangeSelected!(rangeMinDate!, rangeMaxDate);
      }
    }
  }

  void clearSelectedDates() {
    rangeMaxDate = null;
    rangeMinDate = null;
    notifyListeners();
  }

  Future<void> scrollToMonth({
    required DateTime date,
    double alignment = 0,
    required Duration duration,
    Curve curve = Curves.linear,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) async {
    if (!(date.year >= minDate.year &&
        (date.year > minDate.year || date.month >= minDate.month) &&
        date.year <= maxDate.year &&
        (date.year < maxDate.year || date.month <= maxDate.month))) {
      return;
    }
    final month =
        ((date.year - minDate.year) * 12) - minDate.month + date.month;
    await itemScrollController.scrollTo(
        index: month,
        alignment: alignment,
        duration: duration,
        curve: curve,
        opacityAnimationWeights: opacityAnimationWeights);
  }

  void jumpToMonth({required DateTime date, double alignment = 0}) {
    if (!(date.year >= minDate.year &&
        (date.year > minDate.year || date.month >= minDate.month) &&
        date.year <= maxDate.year &&
        (date.year < maxDate.year || date.month <= maxDate.month))) {
      return;
    }
    final month = ((date.year - minDate.year) * 12) - minDate.month + date.month;
    itemScrollController.jumpTo(index: month, alignment: alignment);
  }
}

library scrollable_clean_calendar;

import 'package:calendar/calender/utils/enums.dart';
import 'package:calendar/calender/widgets/days_widget.dart';
import 'package:calendar/calender/widgets/month_widget.dart';
import 'package:calendar/calender/widgets/weekdays_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controllers/horizontal_calendar_controller.dart';
import 'models/day_values_model.dart';

class HorizontalCalendar extends StatefulWidget {
  final String locale;
  final ScrollController? scrollController;
  final bool showWeekdays;
  final Layout? layout;
  final double width;
  final Widget Function(BuildContext context, String month)? monthBuilder;
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;
  final Widget Function(BuildContext context, DayValues values)? dayBuilder;
  final HorizontalCalendarController calendarController;

  const HorizontalCalendar({
    Key? key,
    this.locale = 'en',
    this.scrollController,
    this.showWeekdays = true,
    this.layout = Layout.beauty,
    this.monthBuilder,
    this.weekdayBuilder,
    this.dayBuilder,
    required this.width,
    required this.calendarController,
  }) : assert(layout != null ||
            (monthBuilder != null &&
                weekdayBuilder != null &&
                dayBuilder != null)), super(key: key) ;

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {

  double spaceBetweenMonthAndCalendar = 24;
  double spaceBetweenCalendars = 24;
  double calendarCrossAxisSpacing = 0;
  double calendarMainAxisSpacing = 4;
  double dayRadius = 6;

  @override
  void initState() {
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final focusDate = widget.calendarController.initialFocusDate;
      if (focusDate != null) {
        widget.calendarController.jumpToMonth(date: focusDate);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      //padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      separatorBuilder: (_, __) => SizedBox(height: spaceBetweenCalendars),
      itemCount: widget.calendarController.months.length,
      itemBuilder: (context, index) {
        final month = widget.calendarController.months[index];
        return SizedBox(
          width: widget.width,
          height: widget.width * 1.2,
          child: childColumn(month),
        );
      },
    );
  }

  Widget childColumn(DateTime month) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: MonthWidget(
            month: month,
            locale: widget.locale,
            layout: widget.layout,
            monthBuilder: widget.monthBuilder,
          ),
        ),
        SizedBox(height: spaceBetweenMonthAndCalendar),
        Column(
          children: [
            WeekdaysWidget(
              showWeekdays: widget.showWeekdays,
              cleanCalendarController: widget.calendarController,
              locale: widget.locale,
              layout: widget.layout,
              weekdayBuilder: widget.weekdayBuilder,
            ),
            AnimatedBuilder(
              animation: widget.calendarController,
              builder: (_, __) {
                return DaysWidget(
                  month: month,
                  cleanCalendarController: widget.calendarController,
                  calendarCrossAxisSpacing: calendarCrossAxisSpacing,
                  calendarMainAxisSpacing: calendarMainAxisSpacing,
                  layout: widget.layout,
                  dayBuilder: widget.dayBuilder,
                  radius: dayRadius,
                );
              },
            )
          ],
        )
      ],
    );
  }
}

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/scrolling_years_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  //List<DateTime> getHighlightedDates() {
    // return List<DateTime>.generate(
    //   10,
    //   (int index) => DateTime.now().add(Duration(days: 10 * (index + 1))),
    // );
 // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollingYearsCalendar(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 1 * 30)),
          lastDate: DateTime.now(),
          currentDateColor: Colors.blue,
          // highlightedDates: getHighlightedDates(),
          //highlightedDateColor: Colors.deepOrange,
          monthNames: const <String>[
            'JANUARY',
            'FEBRUARY',
            'MARCH',
            'APRIL',
            'MAY',
            'JUNE',
            'JULY',
            'AUGUST',
            'SEPTEMBER',
            'OCTOBER',
            'NOVEMBER',
            'DECEMBER',
          ],
          onMonthTap: (int year, int month) => print('Tapped $month/$year'),
          monthTitleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
        ),
      ),
    );
  }
}

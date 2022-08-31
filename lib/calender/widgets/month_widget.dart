import 'package:calendar/calender/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/enums.dart';

class MonthWidget extends StatelessWidget {
  final DateTime month;
  final String locale;
  final Layout? layout;
  final Widget Function(BuildContext context, String month)? monthBuilder;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.locale,
    required this.layout,
    required this.monthBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = '${DateFormat('MMMM', locale).format(DateTime(month.year, month.month)).capitalize()} ${DateFormat('yyyy', locale).format(DateTime(month.year, month.month))}';

    if (monthBuilder != null) {
      return monthBuilder!(context, text);
    }

    return <Layout, Widget Function()>{
      Layout.normal: () => _pattern(context, text),
      Layout.beauty: () => _beauty(context, text)
    }[layout]!();
  }

  Widget _pattern(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6!,
    );
  }

  Widget _beauty(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6!,
    );
  }
}

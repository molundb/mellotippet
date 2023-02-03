import 'package:intl/intl.dart';

class UpcomingCompetitionsRowController {
  String formatDate(DateTime time) {
    final DateFormat formatter = DateFormat('MMM dd, HH:mm');
    return formatter.format(time);
  }
}

import 'package:intl/intl.dart';

class UpcomingCompetitionsRowController {
  String formatDate(DateTime time) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(time);
  }
}

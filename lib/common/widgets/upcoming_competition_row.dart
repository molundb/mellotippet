import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/upcoming_competitions/upcoming_competitions_row_controller.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

class UpcomingCompetitionRow extends StatefulWidget {
  final String title;
  final CompetitionModel competition;

  const UpcomingCompetitionRow({
    required this.title,
    required this.competition,
    super.key,
  });

  @override
  State<UpcomingCompetitionRow> createState() => _UpcomingCompetitionRowState();
}

class _UpcomingCompetitionRowState extends State<UpcomingCompetitionRow> {
  UpcomingCompetitionsRowController controller =
      UpcomingCompetitionsRowController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MelloPredixColors.melloYellow,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              'time', // controller.formatDate(widget.competition.time),
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}

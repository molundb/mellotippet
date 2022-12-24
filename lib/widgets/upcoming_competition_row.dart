import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/controllers/upcoming_competitions_row_controller.dart';
import 'package:melodifestivalen_competition/models/competition_model.dart';

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
  UpcomingCompetitionsRowController controller = UpcomingCompetitionsRowController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(widget.title),
          Text(controller.formatDate(widget.competition.time)),
        ],
      ),
    );
  }
}

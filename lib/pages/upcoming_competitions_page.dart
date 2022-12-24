import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/models/competition_model.dart';
import 'package:melodifestivalen_competition/repositories/database_repository.dart';
import 'package:melodifestivalen_competition/widgets/upcoming_competition_row.dart';

class UpcomingCompetitionsPage extends StatefulWidget {
  const UpcomingCompetitionsPage({super.key});

  @override
  State<UpcomingCompetitionsPage> createState() =>
      _UpcomingCompetitionsPageState();
}

class _UpcomingCompetitionsPageState extends State<UpcomingCompetitionsPage> {
  List<CompetitionModel> competitions = [];

  @override
  void initState() {
    super.initState();
    _getUpcomingCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: competitions.length,
          itemBuilder: (BuildContext context, int index) {
            return UpcomingCompetitionRow(
              title: 'Heat ${index + 1}',
              competition: competitions[index],
            );
          },
        ),
      ],
    );
  }

  void _getUpcomingCompetitions() async {
    final databaseRepo = getIt<DatabaseRepository>();

    final competitions = await databaseRepo.getUpcomingCompetitions();
    setState(() {
      this.competitions = competitions;
    });
  }
}

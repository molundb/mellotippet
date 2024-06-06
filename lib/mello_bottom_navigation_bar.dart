import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mellotippet/common/models/competition_model.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar/reusable_app_bar_controller.dart';
import 'package:mellotippet/prediction/final_prediction_page.dart';
import 'package:mellotippet/prediction/heat_prediction_page.dart';
import 'package:mellotippet/prediction/semifinal_prediction_page.dart';
import 'package:mellotippet/rules/rules_page.dart';
import 'package:mellotippet/styles/colors.dart';

import 'score/score_page.dart';

class MelloBottomNavigationBar extends ConsumerStatefulWidget {
  final CompetitionType currentCompetitionType;

  const MelloBottomNavigationBar({
    super.key,
    required this.currentCompetitionType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MelloBottomNavigationBarState();
}

class _MelloBottomNavigationBarState
    extends ConsumerState<MelloBottomNavigationBar> {
  int _selectedIndex = 0;

  // final List<Widget> _widgetOptions = <Widget>[
  //   const ScorePage(),
  //   getPredictionPage(),
  //   const RulesPage(),
  // ];

  final Widget trophyInactive = SvgPicture.asset(
    'assets/icons/navbar_trophy_inactive.svg',
  );

  final Widget trophyActive = SvgPicture.asset(
    'assets/icons/navbar_trophy_active.svg',
  );

  Widget _getWidget(int index) {
    final widgetOptions = [
      const ScorePage(),
      _getPredictionPage(),
      const RulesPage(),
    ];

    return widgetOptions.elementAt(index);
  }

  Widget _getPredictionPage() {
    switch (widget.currentCompetitionType) {
      case CompetitionType.heat:
        return const HeatPredictionPage();
      case CompetitionType.finalkval:
        return const SemifinalPredictionPage();
      case CompetitionType.theFinal:
        return const FinalPredictionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(reusableAppBarControllerProvider, (previous, next) {
      if (next.snackBarText != '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.snackBarText),
          ),
        );
        // controller.clearSnackBarText();
      }
    });

    return Scaffold(
      body: Center(
        child: _getWidget(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: MellotippetColors.melloPurple,
        unselectedItemColor: Colors.white,
        selectedItemColor: MellotippetColors.melloLightOrange,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Padding(
          //     padding: const EdgeInsets.only(bottom: 4.0),
          //     child: trophyInactive,
          //   ),
          //   label: 'Poäng',
          //   activeIcon: Padding(
          //     padding: const EdgeInsets.only(bottom: 4.0),
          //     child: trophyActive,
          //   ),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Poäng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'Tippa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Regler',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

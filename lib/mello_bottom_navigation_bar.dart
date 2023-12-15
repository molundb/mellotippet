import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mellotippet/config/config.dart';
import 'package:mellotippet/prediction/heat_prediction_page.dart';
import 'package:mellotippet/rules/rules_page.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/colors.dart';

import 'score/score_page.dart';

class MelloBottomNavigationBar extends StatefulWidget {
  const MelloBottomNavigationBar({super.key});

  @override
  State<MelloBottomNavigationBar> createState() =>
      _MelloBottomNavigationBarState();
}

class _MelloBottomNavigationBarState extends State<MelloBottomNavigationBar> {
  final config = getIt.get<Config>();

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const ScorePage(),
    HeatPredictionPage(snackbarHandler: getIt.get<SnackbarHandler>()),
    const RulesPage(),
  ];

  final Widget trophyInactive = SvgPicture.asset(
    'assets/icons/navbar_trophy_inactive.svg',
  );

  final Widget trophyActive = SvgPicture.asset(
    'assets/icons/navbar_trophy_active.svg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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

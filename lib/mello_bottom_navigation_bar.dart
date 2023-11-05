import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/config/config.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/rules/final_rules_page.dart';
import 'package:melodifestivalen_competition/snackbar/snackbar_handler.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';

import 'prediction/final_prediction_page.dart';
import 'score/score_page.dart';
import 'settings/settings_page.dart';

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
    FinalPredictionPage(snackbarHandler: getIt.get<SnackbarHandler>()),
    // UpcomingCompetitionsPage(),
    const FinalRulesPage(),
    const ScorePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          config.title,
          style: const TextStyle(
            color: MellotippetColors.melloYellow,
            fontSize: 32,
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'Tippa',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.calendar_month),
          //   label: 'Upcoming',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Rules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
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

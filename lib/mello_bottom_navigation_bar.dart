import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/pages/prediction_page.dart';

class MelloBottomNavigationBar extends StatefulWidget {
  const MelloBottomNavigationBar({super.key});

  @override
  State<MelloBottomNavigationBar> createState() =>
      _MelloBottomNavigationBarState();
}

class _MelloBottomNavigationBarState extends State<MelloBottomNavigationBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    PredictionPage(),
    // UpcomingCompetitionsPage(),
    Text(
      'Score!',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Melodifestivalen Competition'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Predix',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.calendar_month),
          //   label: 'Upcoming',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Score',
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

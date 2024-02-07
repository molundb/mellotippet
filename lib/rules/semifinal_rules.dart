import 'package:flutter/material.dart';

class SemifinalRules extends StatelessWidget {
  const SemifinalRules({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text('Tippning',
                style: TextStyle(fontFamily: 'Inter', fontSize: 24)),
          ),
          Text(
            'Man får tippa hur många gånger man vill. Det är enbart den sista tippningen som räknas. Tippningen stängs strax innan det första resultatet för semifinalen tillkännages.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
            child: Text('Poängräkning',
                style: TextStyle(fontFamily: 'Inter', fontSize: 24)),
          ),
          Text(
            'Rätt på finalist: 3p',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
            child: Text('Miss av finalkval',
                style: TextStyle(fontFamily: 'Inter', fontSize: 24)),
          ),
          Text(
            'Om man inte tippar på finalkvalet får man 1 poäng mindre än den som tippade och fick lägst poäng på finalkvalet. Man har alltså fortfarande en chans att ta hem hela tävlingen!',
            style: TextStyle(fontFamily: 'Inter'),
          )
        ],
      ),
    );
  }
}

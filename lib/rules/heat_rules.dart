import 'package:flutter/material.dart';
import 'package:mellotippet/styles/text_styles.dart';

class HeatRules extends StatelessWidget {
  const HeatRules({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: ListView(
        children: const [
          Text(
            'Efter att alla låtar har spelats och innan det första resultatet har visats så röstar alla på vilka låtar de tror kommer till final, semifinal samt femte plats.'
            ''
            '\n\nOm man har finalist på final (rätt på finalist): 5p'
            '\nOm man har finalist på semifinal: 3p'
            '\nOm man har finalist på 5e plats: 1p'
            ''
            '\n\nOm man har semifinalist på semifinalist (rätt på semifinalist): 2p'
            '\nOm man har semifinalist på final: 1p'
            '\nOm man har semifinalist på 5e plats: 1p'
            ''
            '\n\nOm man missar en deltävling / semifinalist / final får man 1p mindre än den som fick lägst poäng.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }
}

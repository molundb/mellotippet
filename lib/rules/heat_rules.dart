import 'package:flutter/material.dart';
import 'package:mellotippet/styles/text_styles.dart';

class HeatRules extends StatelessWidget {
  const HeatRules({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Text(
            'Man får tippa hur många gånger man vill. Det är enbart den sista tippningen som räknas. Tippningen stängs strax innan det första resultatet för deltävlingen tillkännages.'
            ''
            '\n\nPoäng för finalist:'
            '\n\u2022 Finalist tippad som finalist: 5p'
            '\n\u2022 Finalist tippad som semifinalist: 3p'
            '\n\u2022 Finalist tippad som 5e plats: 1p'
            ''
            '\n\nPoäng för semifinalist:'
            '\n\u2022 Semifinalist tippad som finalist: 1p'
            '\n\u2022 Semifinalist tippad som semifinalist: 2p'
            '\n\u2022 Semifinalist tippad som 5e plats: 1p'
            ''
            '\n\nOm man missar att tippa på en deltävling får man 1 poäng mindre än den som tippade och fick lägst poäng på den deltävlingen.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }
}

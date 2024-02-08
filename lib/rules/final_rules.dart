import 'package:flutter/material.dart';

class FinalRules extends StatelessWidget {
  const FinalRules({
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
            child: Text(
              'Tippning',
              style: TextStyle(fontFamily: 'Inter', fontSize: 24),
            ),
          ),
          Text(
            'Man får tippa hur många gånger man vill. Det är enbart den sista tippningen som räknas. Tippningen stängs strax innan det första resultatet för deltävlingen tillkännages.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
            child: Text(
              'Poängräkning',
              style: TextStyle(fontFamily: 'Inter', fontSize: 24),
            ),
          ),
          Text(
            'Poängsättningen för finalen är indelad i tre grupper:'
            '\n\n\u2022 Grupp 1: låtarna med placering 1-4'
            '\n\u2022 Grupp 2: låtarna med placering 5-8'
            '\n\u2022 Grupp 3: låtarna med placering 9-12'
            '\n\nMan får poäng baserat på hur nära ens tippning är det faktiska resultatet. Man får den högsta möjliga poängen om man prickar helt rätt. Den högsta möjliga poängen är 5 poäng för grupp 1, 3 poäng för grupp 2 och 2 poäng för grupp 3. För varje placering ens tippning är ifrån resultatet får man 1 poäng mindre. Den lägsta poängen man kan få för en låt är 0 poäng - det går inte att få minuspoäng.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
            child: Text(
              'Miss av final',
              style: TextStyle(fontFamily: 'Inter', fontSize: 24),
            ),
          ),
          Text(
            'Om man inte tippar på finalen får man 1 poäng mindre än den som tippade och fick lägst poäng på finalen.',
            style: TextStyle(fontFamily: 'Inter'),
          )
        ],
      ),
    );
  }
}

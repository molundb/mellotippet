import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/styles/text_styles.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Rules for Heat 1-4', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 16),
            const Text(
              'Predict which songs will make it to the final, semi-final and fifth place. You can change your prediction as many times as you want - it is the last one that counts. The predictions close shortly before any song is announced to go to the second voting round.'
              ''
              '\n\nIf you miss predicting in any heat, you get 1p less than the person who got the lowest score in that heat.',
              style: defaultStyle,
            ),
            const SizedBox(height: 32),
            const Text(
              'For each of the two songs that go to the final, you will get 0, 1, 3 or 5 points depending on how correct your prediction is:',
              style: defaultStyle,
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              children: const [
                TableRow(
                  children: [
                    Text(
                      'Your Bet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Finalist',
                    ),
                    Text(
                      '5',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Semi-finalist',
                    ),
                    Text(
                      '3',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Fifth place',
                    ),
                    Text(
                      '1',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'For each of the two songs that go to the semi final, you will get 0, 1 or 2 points depending on how correct your prediction is:',
              style: defaultStyle,
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              children: const [
                TableRow(
                  children: [
                    Text(
                      'Your Bet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Semi-finalist',
                    ),
                    Text(
                      '2',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Finalist',
                    ),
                    Text(
                      '1',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Fifth place',
                    ),
                    Text(
                      '1',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text buildText() {
    return const Text(
      'Bet on which songs will make it to the final, semi-final and fifth place. You can bet as many times as you want - your last bet is what counts. The betting closes shortly before any song is announced to go to the second voting round.'
      ''
      '\n\n• For each finalist you had as a finalist: 5p'
      ''
      '\n\n• For each finalist you had as a semi-finalist: 3p'
      ''
      '\n\n• For each finalist you had as 5th place: 1p'
      ''
      '\n\n• For each semi-finalist you had as semi-finalist: 2p'
      ''
      '\n\n• For each semi-finalist you had as a finalist: 1p'
      ''
      '\n\n• For each semi-finalist you had as 5th place: 1p'
      ''
      '\n\nIf you miss betting in any competition, you get 1p less than the person who got the lowest score in that competition.',
      style: defaultStyle,
    );
  }
}

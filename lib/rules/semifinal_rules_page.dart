import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/styles/colors.dart';
import 'package:mellotippet/styles/text_styles.dart';

class SemifinalRulesPage extends ConsumerWidget {
  const SemifinalRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Text('Rules for the Semifinal',
              style: TextStyle(
                fontSize: 32,
                color: MellotippetColors.melloLightOrange,
              )),
          SizedBox(height: 16),
          Text(
            'Predict which songs will make it to the final. You can change your prediction as many times as you want - it is the last one that counts. The predictions close shortly before the first voting result is announced.'
            ''
            '\n\nIf you miss predicting the Semifinal, you get 1p less than the person who got the lowest score.',
            style: MellotippetTextStyle.defaultStyle,
          ),
          SizedBox(height: 32),
          Text(
            'For each of the four songs that go to the final, you will get 0 or 2 points depending on if your prediction is correct or not.',
            style: MellotippetTextStyle.defaultStyle,
          ),
        ],
      ),
    );
  }
}

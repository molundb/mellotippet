import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/styles/colors.dart';
import 'package:mellotippet/styles/text_styles.dart';

class FinalRulesPageOld extends ConsumerWidget {
  const FinalRulesPageOld({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: ListView(
        children: const [
          Center(
            child: Text(
              'Rules for the Final',
              style: TextStyle(
                fontSize: 32,
                color: MellotippetColors.melloLightOrange,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Predict the position of each song in the final. You can change your prediction as many times as you want - it is the last one that counts. The predictions close shortly before the first voting result is announced.'
            ''
            '\n\nIf you miss predicting the Final, you get 1p less than the person who got the lowest score.',
            style: MellotippetTextStyle.defaultStyle,
          ),
          SizedBox(height: 32),
          Text(
            'The scoring for the final is divided into three groups:'
            '\n\ngroup 1: positions 1-4'
            '\ngroup 2: positions 5-8'
            '\ngroup 3: positions 9-12'
            '\n\nFor each of the groups you get points based on how close your prediction is to the actual result. For group 1 the maximum achievable points is 5p, for group 2 it is 3p, and for group 3 it is 2p. If your prediction is exactly right you get the maximum points. If your prediction is one position off you get the maximum points minus 1. If your prediction is two positions off you get the maximum points minus 2. And so on. It is not possible to get minus points.',
            style: MellotippetTextStyle.defaultStyle,
          ),
        ],
      ),
    );
  }
}

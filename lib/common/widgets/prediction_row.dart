import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRow extends StatefulWidget {
  const PredictionRow({
    super.key,
  });

  @override
  PredictionRowState createState() => PredictionRowState();
}

class PredictionRowState extends State<PredictionRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MellotippetColors.melloPurple,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Container(
              color: MellotippetColors.melloMagenta,
              width: 45,
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tone Sekelius'),
                  Text('Rhythm of My Show'),
                ],
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 27,
              height: 27,
              child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: MellotippetColors.melloOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const Center(child: Text("1")),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: MellotippetColors.melloMagenta,
                width: 45,
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tone Sekelius',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      'Rhythm of My Show',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
      ),
    );
  }
}

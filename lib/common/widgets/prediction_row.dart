import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRow extends StatefulWidget {
  final String imageAsset;

  const PredictionRow({
    super.key,
    this.imageAsset = 'assets/images/tone-sekelius.png',
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
              Image.asset(
                widget.imageAsset,
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
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: MellotippetColors.melloLightOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "1",
                        style: TextStyle(color: MellotippetColors.melloPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

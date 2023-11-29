import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRowFeedbackDuringDrag extends StatefulWidget {
  final String imageAsset;

  const PredictionRowFeedbackDuringDrag({
    super.key,
    this.imageAsset = 'assets/images/tone-sekelius.png',
  });

  @override
  PredictionRowFeedbackDuringDragState createState() =>
      PredictionRowFeedbackDuringDragState();
}

class PredictionRowFeedbackDuringDragState
    extends State<PredictionRowFeedbackDuringDrag> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: const BoxDecoration(
          color: MellotippetColors.melloPurple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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

import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRow extends StatefulWidget {
  final String artist;
  final String song;
  final String imageAsset;
  final int startNumber;
  final PredictedPosition prediction;

  const PredictionRow({
    super.key,
    required this.artist,
    required this.song,
    required this.imageAsset,
    required this.startNumber,
    this.prediction = PredictedPosition.notPlaced,
  });

  PredictionRow copyWithPredictionPosition(PredictedPosition prediction) =>
      PredictionRow(
        artist: artist,
        song: song,
        imageAsset: imageAsset,
        startNumber: startNumber,
        prediction: prediction,
      );

  @override
  PredictionRowState createState() => PredictionRowState();
}

class PredictionRowState extends State<PredictionRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.prediction.gradientStartColor,
                widget.prediction.gradientStartColor,
                Colors.white
              ],
              stops: const [0, 0.4, 1.4],
            ),
          ),
          child: Content(widget: widget)),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.widget,
  });

  final PredictionRow widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Image.asset(
              widget.imageAsset,
              width: 45,
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.artist,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    widget.song,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            if (widget.prediction != PredictedPosition.notPlaced) ...[
              SizedBox(
                width: 110,
                height: 24,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD58E),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${widget.prediction.text}',
                        style: const TextStyle(
                          color: MellotippetColors.black,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
            ] else ...[
              Container(),
            ],
            const Icon(
              Icons.menu,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

enum PredictedPosition {
  finalist(
    text: 'Final',
    gradientStartColor: MellotippetColors.melloLightOrange,
  ),
  semifinalist(
    text: 'Andra chansen',
    gradientStartColor: MellotippetColors.semifinalistGradientGray,
  ),
  fifthPlace(
    text: '5:e plats',
    gradientStartColor: MellotippetColors.fifthPlaceGradientBrown,
  ),
  notPlaced(
    text: '',
    gradientStartColor: Colors.black,
  );

  const PredictedPosition({
    required this.text,
    required this.gradientStartColor,
  });

  final String text;
  final Color gradientStartColor;
}

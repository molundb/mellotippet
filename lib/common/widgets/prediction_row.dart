import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRow extends StatefulWidget {
  final String artist;
  final String song;
  final String imageAsset;
  final int startNumber;
  final String? prediction;
  final bool dragging;

  const PredictionRow({
    super.key,
    required this.artist,
    required this.song,
    required this.imageAsset,
    required this.startNumber,
    this.prediction,
    this.dragging = false,
  });

  PredictionRow copyWithDraggingTrue() => PredictionRow(
        artist: artist,
        song: song,
        imageAsset: imageAsset,
        startNumber: startNumber,
        dragging: true,
      );

  PredictionRow copyWithPrediction(String? prediction) => PredictionRow(
        artist: artist,
        song: song,
        imageAsset: imageAsset,
        startNumber: startNumber,
        prediction: prediction,
        dragging: dragging,
      );

  @override
  PredictionRowState createState() => PredictionRowState();
}

class PredictionRowState extends State<PredictionRow> {
  @override
  Widget build(BuildContext context) {
    return widget.dragging
        ? Container(
            decoration: const BoxDecoration(
              color: MellotippetColors.melloPurple,
            ),
            child: Content(widget: widget))
        : Card(
            color: MellotippetColors.melloPurple,
            child: Content(widget: widget),
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
            if (widget.prediction != null) ...[
              Expanded(child: Container()),
              SizedBox(
                width: 24,
                height: 24,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: MellotippetColors.melloLightOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${widget.prediction}',
                        style: const TextStyle(color: MellotippetColors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(),
            ]
          ],
        ),
      ),
    );
  }
}

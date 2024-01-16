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
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.imageAsset,
                ),
                CustomPaint(
                  painter: TriangleCoveringPhoto(
                      color: widget.prediction.gradientStartColor),
                  size: const Size(68, 60),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
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
            ),
            Expanded(child: Container()),
            if (widget.prediction != PredictedPosition.notPlaced) ...[
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: SizedBox(
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
                          widget.prediction.text,
                          style: const TextStyle(
                            color: MellotippetColors.black,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(),
            ],
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.menu,
                size: 14,
              ),
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

class TriangleCoveringPhoto extends CustomPainter {
  Color color;

  TriangleCoveringPhoto({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final path = Path();
    path.moveTo(width, 0); // Top right corner
    path.lineTo(width, height); // Bottom right corner
    path.lineTo(width / 3 * 2, height); // Bottom left corner
    path.close();

    final paint = Paint()..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

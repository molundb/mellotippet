import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRow extends StatefulWidget {
  final String artist;
  final String song;
  final String? imageAsset;
  final int startNumber;
  final PredictedPosition prediction;

  const PredictionRow({
    super.key,
    required this.artist,
    required this.song,
    this.imageAsset,
    required this.startNumber,
    required this.prediction,
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
    final rhombusText = widget.prediction.text;
    final imageAsset = widget.imageAsset;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            if (imageAsset != null) ...[
              Stack(
                children: [
                  Image.asset(
                    imageAsset,
                  ),
                  CustomPaint(
                    painter: TriangleCoveringPhoto(
                        color: widget.prediction.gradientStartColor),
                    size: const Size(106.8, 60),
                  ),
                ],
              ),
            ],
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.artist,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      widget.song,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            if (rhombusText != null) ...[
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: SizedBox(
                  width: 80,
                  height: 24,
                  child: Stack(
                    children: [
                      Container(
                        transform: Matrix4.skewX(-.4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD58E),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            rhombusText,
                            style: const TextStyle(
                              color: MellotippetColors.black,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

class PredictedPosition {
  factory PredictedPosition.finalPosition({required String text}) =>
      PredictedPosition(
        text: text,
        gradientStartColor: MellotippetColors.melloLightOrange,
      );

  factory PredictedPosition.finalist() => const PredictedPosition(
        text: 'Final',
        gradientStartColor: MellotippetColors.melloLightOrange,
      );

  factory PredictedPosition.semifinalist() => const PredictedPosition(
        text: 'Semifinal',
        gradientStartColor: MellotippetColors.semifinalistGradientGray,
      );

  factory PredictedPosition.fifthPlace() => const PredictedPosition(
        text: '5:e plats',
        gradientStartColor: MellotippetColors.fifthPlaceGradientBrown,
      );

  factory PredictedPosition.notPlaced() => const PredictedPosition(
        gradientStartColor: Colors.black,
      );

  const PredictedPosition({
    this.text,
    required this.gradientStartColor,
  });

  final String? text;
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

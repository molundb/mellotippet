import 'package:flutter/material.dart';
import 'package:mellotippet/styles/colors.dart';

class PredictionRowListTile extends StatefulWidget {
  final String imageAsset;

  const PredictionRowListTile({
    super.key,
    this.imageAsset = 'assets/images/tone-sekelius.png',
  });

  @override
  PredictionRowListTileState createState() => PredictionRowListTileState();
}

class PredictionRowListTileState extends State<PredictionRowListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MellotippetColors.melloPurple,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6.0),
        leading: Image.asset(
          widget.imageAsset,
          width: 45,
          height: 40,
        ),
        title: const Text(
          'Tone Sekelius',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        subtitle: const Text(
          'Rhythm of My Show',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
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
      ),
    );
  }
}

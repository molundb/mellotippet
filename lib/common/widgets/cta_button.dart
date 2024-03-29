import 'package:flutter/material.dart';
import 'package:mellotippet/styles/all_styles.dart';

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      disabledBackgroundColor: MellotippetColors.disabledCtaBackground,
      disabledForegroundColor: MellotippetColors.disabledCtaForeground,
      backgroundColor: MellotippetColors.melloBlue,
      foregroundColor: Colors.white,
      minimumSize: const Size(121, 31),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

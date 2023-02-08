import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        child: Text(text),
      ),
    );
  }
}

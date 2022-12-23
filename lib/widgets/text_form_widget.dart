import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String? hintText;
  final Widget? prefixIcon;
  final String? defaultText;
  final bool obscureText;
  final Function(String?)? onSaved;

  const TextFormFieldWidget(
      {Key? key,
      required this.textInputType,
      this.hintText,
      this.defaultText,
      this.obscureText = false,
      this.onSaved,
      this.prefixIcon})
      : super(key: key);

  @override
  TextFormFieldWidgetState createState() => TextFormFieldWidgetState();
}

class TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  double bottomPaddingToError = 12;
  Color primaryColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
      ),
      child: TextFormField(
        cursorColor: primaryColor,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.2,
        ),
        initialValue: widget.defaultText,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          contentPadding: EdgeInsets.only(
              top: 12, bottom: bottomPaddingToError, left: 8.0, right: 8.0),
          isDense: true,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        onSaved: widget.onSaved,
      ),
    );
  }
}

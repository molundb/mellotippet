import 'package:flutter/material.dart';
import 'package:melodifestivalen_competition/styles/colors.dart';
import 'package:melodifestivalen_competition/styles/text_styles.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String? hintText;
  final Widget? prefixIcon;
  final String? defaultText;
  final bool obscureText;
  final Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;

  const TextFormFieldWidget({
    Key? key,
    required this.textInputType,
    this.hintText,
    this.defaultText,
    this.obscureText = false,
    this.onSaved,
    this.validator,
    this.prefixIcon,
  }) : super(key: key);

  @override
  TextFormFieldWidgetState createState() => TextFormFieldWidgetState();
}

class TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  var _borderColor = MelloPredixColors.melloPurple;
  var _textColor = Colors.black;
  double bottomPaddingToError = 12;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        MelloPredixTextStyle.inputStyle.copyWith(color: _textColor);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        style: textStyle,
        initialValue: widget.defaultText,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _borderColor),
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          contentPadding: EdgeInsets.only(
            top: 12,
            bottom: bottomPaddingToError,
            left: 8.0,
            right: 8.0,
          ),
          isDense: true,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        onSaved: widget.onSaved,
        autovalidateMode: widget.validator == null
            ? null
            : AutovalidateMode.onUserInteraction,
        validator: widget.validator == null
            ? null
            : (text) {
                final errorMessage = widget.validator!(text);
                _onError(errorMessage != null);
                return errorMessage;
              },
      ),
    );
  }

  void _onError(bool hasError) {
    final borderColor =
        hasError ? MelloPredixColors.danger : MelloPredixColors.itemGray;
    final textColor = hasError ? MelloPredixColors.danger : Colors.black;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      if (_borderColor != borderColor) {
        setState(() {
          _borderColor = borderColor;
        });
      }

      if (_textColor != textColor) {
        setState(() {
          _textColor = textColor;
        });
      }
    });
  }
}

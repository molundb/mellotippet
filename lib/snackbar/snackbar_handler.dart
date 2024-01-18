import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mellotippet/styles/all_styles.dart';
import 'package:mellotippet/common/extensions/all_extensions.dart';

class SnackbarHandler {
  final GlobalKey<ScaffoldMessengerState> _snackbarKey;
  final Logger _logger;

  SnackbarHandler(
    this._snackbarKey,
    this._logger,
  );

  void showText({
    required String title,
    String? description,
    SnackbarAlertLevel level = SnackbarAlertLevel.info,
    Duration duration = const Duration(seconds: 5),
  }) {
    if (title.isEmpty) {
      _logger.e('SnackBarHandler called with blank title');
      return;
    }

    final snackBar = SnackBar(
      key: const Key('snackbar'),
      content: _getContent(title: title, description: description),
      backgroundColor: level.backgroundColor,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 10.0),
      margin: const EdgeInsets.only(
        left: MellotippetDimensions.horizontalPadding,
        right: MellotippetDimensions.horizontalPadding,
        bottom: 120.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MellotippetDimensions.cornerRadiusSmall),
      ),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      // action: SnackBarAction(
      //   key: const Key('snackbar_close_button'),
      //   label: 'Stäng',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     _snackbarKey.currentState?.hideCurrentSnackBar();
      //   },
      // ),
    );

    _snackbarKey.currentState?.showSnackBar(snackBar);
  }

  Widget _getContent({
    required String title,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            key: const Key('snackbar_title_text'),
            style: MellotippetTextStyle.defaultStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          description.isNullOrBlank
              ? null
              : Text(
                  description!,
                  key: const Key('snackbar_description_text'),
            style: MellotippetTextStyle.defaultStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
        ].filterNulls(),
      ),
    );
  }
}

enum SnackbarAlertLevel { info, success, error }

extension SnackBarAlertLevelColor on SnackbarAlertLevel {
  Color get backgroundColor {
    switch (this) {
      case SnackbarAlertLevel.info:
        return MellotippetColors.info;
      case SnackbarAlertLevel.success:
        return MellotippetColors.success;
      case SnackbarAlertLevel.error:
        return MellotippetColors.danger;
    }
  }
}

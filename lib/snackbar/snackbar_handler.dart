import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:melodifestivalen_competition/styles/all_styles.dart';
import 'package:melodifestivalen_competition/common/extensions/all_extensions.dart';

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
    Duration duration = const Duration(days: 365),
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
        left: MelloPredixDimensions.horizontalPadding,
        right: MelloPredixDimensions.horizontalPadding,
        bottom: 120.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MelloPredixDimensions.cornerRadiusSmall),
      ),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      action: SnackBarAction(
        key: const Key('snackbar_close_button'),
        label: 'close',
        textColor: Colors.white,
        onPressed: () {
          _snackbarKey.currentState?.hideCurrentSnackBar();
        },
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            key: const Key('snackbar_title_text'),
            style: MelloPredixTextStyle.defaultStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          description.isNullOrBlank
              ? null
              : Text(
                  description!,
                  key: const Key('snackbar_description_text'),
                  style: MelloPredixTextStyle.defaultStyle.copyWith(
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
        return MelloPredixColors.info;
      case SnackbarAlertLevel.success:
        return MelloPredixColors.success;
      case SnackbarAlertLevel.error:
        return MelloPredixColors.danger;
    }
  }
}
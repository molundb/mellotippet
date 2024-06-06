import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/prediction_page_app_bar/prediction_page_app_bar_controller.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar/reusable_app_bar.dart';

class PredictionPageAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const PredictionPageAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PredictionPageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _PredictionPageAppBarState extends ConsumerState<PredictionPageAppBar> {
  PredictionPageAppBarController get controller =>
      ref.read(predictionPageAppBarControllerProvider.notifier);

  @override
  void initState() {
    controller.getAppBarSubtitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(predictionPageAppBarControllerProvider);

    return ReusableAppBar(
      title: 'Tippa',
      subtitle: state.appBarSubtitle,
    );
  }
}

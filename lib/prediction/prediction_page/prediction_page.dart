import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_page_app_bar/prediction_page_app_bar.dart';
import 'package:mellotippet/prediction/prediction_page/prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/all_styles.dart';

class PredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;
  final String emptyTopListText;
  final PredictionController controller;

  const PredictionPage({
    super.key,
    required this.snackbarHandler,
    required this.emptyTopListText,
    required this.controller,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PredictionPageState();
}

class PredictionPageState extends ConsumerState<PredictionPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.controller.getNotifier());

    return Scaffold(
      appBar: const PredictionPageAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DragAndDropLists(
                children: [
                  DragAndDropList(
                    children: state.songLists[0]
                        .map((song) => DragAndDropItem(child: song))
                        .toList(),
                    canDrag: false,
                    contentsWhenEmpty: Padding(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Text(
                        widget.emptyTopListText,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0,
                          color: MellotippetColors.gray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  DragAndDropList(
                    children: state.songLists[1]
                        .map((song) => DragAndDropItem(child: song))
                        .toList(),
                    canDrag: false,
                    contentsWhenEmpty: Container(),
                  ),
                ],
                listDivider: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Divider(thickness: 1),
                ),
                listDividerOnLastChild: false,
                itemDragOnLongPress: false,
                onItemReorder: widget.controller.onItemReorder,
                onListReorder: (int x, int y) {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CtaButton(
              text: "Tippa",
              onPressed: state.ctaEnabled ? () => _submit(context) : null,
            ),
          )
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    final successful = await widget.controller.submitPrediction();

    if (successful) {
      widget.snackbarHandler.showText(
        title: 'Tippet sparat!',
        level: SnackbarAlertLevel.success,
      );
    } else {
      widget.snackbarHandler.showText(
        title: 'Tippet misslyckades!',
        level: SnackbarAlertLevel.error,
      );
    }
  }
}

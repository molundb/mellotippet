import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/prediction/heat_prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/all_styles.dart';

class HeatPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const HeatPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HeatPredictionPageState();
}

class _HeatPredictionPageState extends ConsumerState<HeatPredictionPage> {
  HeatPredictionController get controller =>
      ref.read(HeatPredictionController.provider.notifier);

  final DragAndDropList _predicted = DragAndDropList(children: []);
  final DragAndDropList _notPredicted = DragAndDropList(children: []);
  List<DragAndDropList> _contents = [];

  @override
  void initState() {
    super.initState();

    // Generate a list
    // _contents = List.generate(10, (index) {
    //   return DragAndDropList(
    //     header: Text('Header $index'),
    //     children: <DragAndDropItem>[
    //       DragAndDropItem(
    //         child: Text('$index.1'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.2'),
    //       ),
    //       DragAndDropItem(
    //         child: Text('$index.3'),
    //       ),
    //     ],
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(HeatPredictionController.provider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text(
          'Tippa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontFamily: 'Lalezar',
          ),
        ),
        // TODO: add info about competition
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: DragAndDropLists(
              // children: [
              //   DragAndDropList(children: state.songLists[0]),
              //   DragAndDropList(children: state.songLists[1]),
              // ],
              children: [
                DragAndDropList(
                  children: state.songLists[0]
                      .map((e) => DragAndDropItem(child: e))
                      .toList(),
                  canDrag: false,
                  contentsWhenEmpty: const Text(
                    'Dra fem bidrag över linjen och rangordna för att tippa',
                    style: TextStyle(
                      color: MellotippetColors.gray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                DragAndDropList(
                  children: state.songLists[1]
                      .map((e) => DragAndDropItem(child: e))
                      .toList(),
                  canDrag: false,
                ),
              ],
              listDivider: const Divider(thickness: 1),
              listDividerOnLastChild: false,
              itemDragOnLongPress: false,
              onItemReorder: controller.onItemReorder,
              onListReorder: (int x, int y) {},
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     toolbarHeight: 120,
    //     centerTitle: true,
    //     title: const Text(
    //       'Tippa',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 64,
    //         fontFamily: 'Lalezar',
    //       ),
    //     ),
    //     // TODO: add info about competition
    //   ),
    //   body: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 32,
    //           horizontal: 16,
    //         ),
    //         child: Column(
    //           children: [
    //             const Text(
    //               'Dra fem bidrag över linjen och rangordna för att tippa',
    //               style: TextStyle(
    //                 color: MellotippetColors.gray,
    //                 fontStyle: FontStyle.italic,
    //               ),
    //             ),
    //             const SizedBox(height: 16.0),
    //             const Divider(thickness: 1),
    //             DragAndDropLists(
    //               children: _contents,
    //               onItemReorder: _onItemReorder,
    //               onListReorder: _onListReorder,
    //             )
    //             // OtherList(others: state.others),
    //           ],
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(12.0),
    //         child: CtaButton(
    //           text: "Tippa",
    //           onPressed:
    //               state.ctaEnabled ? () => _submitPressed(context) : null,
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  void _submitPressed(BuildContext context) {
    // if (_formKey.currentState!.validate()) {

    _submit(context);
  }

  void _submit(BuildContext context) async {
    final successful = await controller.submitPrediction();

    if (successful) {
      widget.snackbarHandler.showText(
        title: 'Upload Successful!',
        level: SnackbarAlertLevel.success,
      );
    } else {
      widget.snackbarHandler.showText(
        title: 'Upload Failed!',
        level: SnackbarAlertLevel.error,
      );
    }
  }
}

class OtherList extends StatelessWidget {
  const OtherList({
    super.key,
    required this.others,
  });

  final List<PredictionRow> others;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: others.length,
      itemBuilder: (context, index) {
        return LayoutBuilder(
          key: Key('$index'),
          builder: (context, constraints) => Draggable<PredictionRow>(
            axis: Axis.vertical,
            data: others[index],
            feedback: Material(
              child: SizedBox(
                width: constraints.maxWidth,
                child: others[index].copyWithDraggingTrue(),
              ),
            ),
            childWhenDragging: Container(
              height: 60.0,
            ),
            child: others[index],
          ),
        );
      },
    );
  }
}

class DragTargetRow extends StatelessWidget {
  const DragTargetRow({
    super.key,
    required this.row,
    required this.index,
    required this.emptyText,
    required this.setRow,
    required this.clearRow,
  });

  final PredictionRow? row;
  final int index;
  final String emptyText;
  final Function(PredictionRow? row, int index) setRow;
  final Function(int index) clearRow;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (BuildContext context,
          List<PredictionRow?> candidateData,
          List rejectedData,) {
        if (candidateData.isNotEmpty) {
          return Opacity(opacity: 0.5, child: candidateData.first);
        } else {
          final row = this.row;
          return row != null
              ? LayoutBuilder(
            key: Key('$index'),
            builder: (context, constraints) => Draggable<PredictionRow>(
              axis: Axis.vertical,
              data: row,
              feedback: Material(
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: row.copyWithDraggingTrue(),
                ),
              ),
              childWhenDragging: Container(
                height: 60.0,
              ),
              child: row,
              onDragStarted: () {
                clearRow(index);
              },
              onDraggableCanceled: (Velocity v, Offset o) {
                setRow(row, index);
              },
            ),
          )
              : EmptyPredictionRow(
            text: emptyText,
          );
        }
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (PredictionRow data) {
        setRow(data, index);
      },
    );
  }
}

class EmptyPredictionRow extends StatelessWidget {
  const EmptyPredictionRow({
    super.key,
    this.backgroundColor = Colors.transparent,
    required this.text,
  });

  final Color backgroundColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        height: 52.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: backgroundColor,
          border: Border.all(color: MellotippetColors.melloPurple),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/prediction_row_feedback_during_drag.dart';
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
  final _formKey = GlobalKey<FormState>();

  HeatPredictionController get controller =>
      ref.read(HeatPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();
      controller.setOthers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(HeatPredictionController.provider);

    // TODO: Figure out how to handle loading

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  children: [
                    const Center(child: Text('Final')),
                    const SizedBox(height: 8.0),
                    DragTargetRow(
                      row: state.predictions[0],
                      index: 0,
                      emptyText: "Finalist",
                      setRow: controller.setRow,
                      clearRow: controller.clearRow,
                    ),
                    const SizedBox(height: 8.0),
                    DragTargetRow(
                      row: state.predictions[1],
                      index: 1,
                      emptyText: "Finalist",
                      setRow: controller.setRow,
                      clearRow: controller.clearRow,
                    ),
                    const SizedBox(height: 8.0),
                    const Center(child: Text('Semifinal')),
                    const SizedBox(height: 8.0),
                    DragTargetRow(
                      row: state.predictions[2],
                      index: 2,
                      emptyText: "Semifinalist",
                      setRow: controller.setRow,
                      clearRow: controller.clearRow,
                    ),
                    const SizedBox(height: 8.0),
                    DragTargetRow(
                      row: state.predictions[3],
                      index: 3,
                      emptyText: "Semifinalist",
                      setRow: controller.setRow,
                      clearRow: controller.clearRow,
                    ),
                    const SizedBox(height: 8.0),
                    const Center(child: Text('Plats 5')),
                    const SizedBox(height: 8.0),
                    DragTargetRow(
                      row: state.predictions[4],
                      index: 4,
                      emptyText: "Plats 5",
                      setRow: controller.setRow,
                      clearRow: controller.clearRow,
                    ),
                    const SizedBox(height: 8.0),
                    const Center(child: Text('Övriga')),
                    const SizedBox(height: 8.0),
                    OtherList(others: state.others),
                    const SizedBox(height: 8.0),
                    CtaButton(
                      text: "Tippa",
                      onPressed: controller.submitPrediction,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!controller.duplicatePredictions()) {
        _submit(context);
      } else {
        widget.snackbarHandler.showText(
          title: 'Error: same prediction in multiple positions',
        );
      }
    }
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
                  child: PredictionRowFeedbackDuringDrag(
                          startNumber: others[index].startNumber)),
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
      builder: (
        BuildContext context,
        List<PredictionRow?> candidateData,
        List rejectedData,
      ) {
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
                          child: PredictionRowFeedbackDuringDrag(
                              startNumber: row.startNumber)),
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

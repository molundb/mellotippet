import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/prediction_row_feedback_during_drag.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/prediction/heat_prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

class HeatPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const HeatPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HeatPredictionPageState();
}

class _HeatPredictionPageState extends ConsumerState<HeatPredictionPage> {
  final List<PredictionRow> _items = List<PredictionRow>.generate(
      6,
      (int index) => PredictionRow(
            key: Key('$index'),
            startNumber: index + 1,
          ));

  final _formKey = GlobalKey<FormState>();

  PredictionRowWrapper finalist1PredictionRow = PredictionRowWrapper();
  PredictionRowWrapper finalist2PredictionRow = PredictionRowWrapper();

  FinalPredictionController get controller =>
      ref.read(FinalPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(HeatPredictionController.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(child: Text('Final')),
            const SizedBox(height: 8.0),
            _createDragTarget(finalist1PredictionRow),
            const SizedBox(height: 8.0),
            _createDragTarget(finalist2PredictionRow),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('Övriga')),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: ListView(
                children: <Widget>[
                  for (int index = 0; index < _items.length; index += 1)
                    // _items[index]
                    LayoutBuilder(
                      key: Key('$index'),
                      builder: (context, constraints) =>
                          Draggable<PredictionRow>(
                        axis: Axis.vertical,
                        data: _items[index],
                        feedback: Material(
                          child: SizedBox(
                              width: constraints.maxWidth,
                              child: PredictionRowFeedbackDuringDrag(
                                  startNumber: _items[index].startNumber)),
                        ),
                        childWhenDragging: Container(
                          height: 60.0,
                        ),
                        child: _items[index],
                        onDragCompleted: () {
                          _items.removeAt(index);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        // const PredictionRow(
        //     imageAsset: 'assets/images/tone-sekelius.png'),
        // const PredictionRowListTile(),
        // const PredictionRow(),
        // const PredictionRow(),
        // const PredictionRow(),
        // const PredictionRow(),
      ),
    );
  }

  DragTarget<PredictionRow> _createDragTarget(PredictionRowWrapper rowWrapper) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<PredictionRow?> candidateData,
        List rejectedData,
      ) {
        if (candidateData.isNotEmpty) {
          return rowWrapper.row != null
              ? Opacity(opacity: 0.5, child: rowWrapper.row!)
              : const EmptyPredictionRow(backgroundColor: Colors.orangeAccent);
        } else {
          return rowWrapper.row != null
              ? rowWrapper.row!
              : const EmptyPredictionRow();
        }
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (PredictionRow data) {
        setState(() {
          if (rowWrapper.row != null) {
            _items.add(rowWrapper.row!);
          }
          rowWrapper.row = data;
        });
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

class EmptyPredictionRow extends StatelessWidget {
  const EmptyPredictionRow({
    super.key,
    this.backgroundColor = Colors.grey,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: backgroundColor,
        ),
        child: const Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            children: [Expanded(child: Center(child: Text("Finalist")))],
          ),
        ),
      ),
    );
  }
}

class PredictionRowWrapper {
  PredictionRow? row;

  PredictionRowWrapper({this.row});
}

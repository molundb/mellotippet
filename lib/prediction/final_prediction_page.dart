import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/prediction_row_feedback_during_drag.dart';
import 'package:mellotippet/common/widgets/prediction_row_list_tile.dart';
import 'package:mellotippet/common/widgets/text_form_widget.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/prediction/row_with_drag_version.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';
import 'package:mellotippet/styles/colors.dart';

class FinalPredictionPage extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const FinalPredictionPage({super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinalPredictionPageState();
}

class _FinalPredictionPageState extends ConsumerState<FinalPredictionPage> {
  final List<RowWithDragVersion> _items = List<RowWithDragVersion>.generate(
      6,
      (int index) => RowWithDragVersion(
          row: PredictionRow(
            key: Key('$index'),
            startNumber: index + 1,
          ),
          rowFeedbackDuringDrag: PredictionRowFeedbackDuringDrag(
            key: Key('$index'),
            startNumber: index + 1,
          )));

  final _formKey = GlobalKey<FormState>();

  RowWithDragVersion? finalist1;
  RowWithDragVersion? finalist2;

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
    final state = ref.watch(FinalPredictionController.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(child: Text('Final')),
            const SizedBox(height: 8.0),
            DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return finalist1?.row != null
                    ? finalist1!.row
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.grey,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text("You can drag here!")))
                              ],
                            ),
                          ),
                        ),
                      );
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (PredictionRowFeedbackDuringDrag data) {
                setState(() {
                  if (finalist1?.row != null) {
                    _items.add(finalist1!);
                  }
                  finalist1?.row = data;
                });
              },
            ),
            const SizedBox(height: 8.0),
            DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return finalist2?.row != null
                    ? finalist2!.row
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.grey,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text("You can drag here too!")))
                              ],
                            ),
                          ),
                        ),
                      );
              },
              onWillAccept: (data) {
                print('trueDrop');
                return true;
              },
              onAccept: (PredictionRowFeedbackDuringDrag data) {
                setState(() {
                  if (finalist2 != null) {
                    _items.add(finalist2!);
                  }
                  finalist2 = data;
                });
              },
            ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: LayoutBuilder(
                        key: Key('$index'),
                        builder: (context, constraints) =>
                            Draggable<PredictionRowFeedbackDuringDrag>(
                          axis: Axis.vertical,
                          data: _items[index],
                          feedback: Material(
                            child: SizedBox(
                                width: constraints.maxWidth,
                                child: _items[index]),
                          ),
                          childWhenDragging: Container(
                            height: 60.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: _items[index],
                          ),
                          onDragCompleted: () {
                            _items.removeAt(index);
                          },
                        ),
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

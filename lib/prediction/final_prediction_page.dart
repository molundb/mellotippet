import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/cta_button.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/prediction_row_list_tile.dart';
import 'package:mellotippet/common/widgets/text_form_widget.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
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
  final List<PredictionRow> _items = List<PredictionRow>.generate(
      6, (int index) => PredictionRow(key: Key('$index')));

  final _formKey = GlobalKey<FormState>();

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
                return Padding(
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
                              child: Center(child: Text("You can drag here!")))
                        ],
                      ),
                    ),
                  ),
                );
              },
              onWillAccept: (data) {
                return data == 'red';
              },
              onAccept: (data) {
                setState(() {
                  print('dropped');
                });
              },
            ),
            const SizedBox(height: 8.0),
            Draggable<String>(
              // Data is the value this Draggable stores.
              data: 'red',
              feedback: Container(
                height: 120.0,
                width: 120.0,
                decoration:
                    const BoxDecoration(color: MellotippetColors.melloBlue),
                child: const Center(
                  child: Text(
                    'Moving',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              child: const PredictionRow(),
              // feedback: PredictionRow(),
              // child: PredictionRow(),
            ),
            // Flexible(
            //   child: ReorderableListView(
            //     // header: const Center(child: Text('Final')),
            //     shrinkWrap: true,
            //     children: <Widget>[
            //       for (int index = 0; index < 2; index += 1)
            //         // _items[index]
            //         _items[index]
            //     ],
            //     onReorder: (int oldIndex, int newIndex) {
            //       setState(() {
            //         if (oldIndex < newIndex) {
            //           newIndex -= 1;
            //         }
            //         final PredictionRow item = _items.removeAt(oldIndex);
            //         _items.insert(newIndex, item);
            //       });
            //     },
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('Startfältet')),
            ),
            Flexible(
              child: ReorderableListView(
                // header: const Center(child: Text('Startfältet')),
                children: <Widget>[
                  for (int index = 0; index < _items.length; index += 1)
                    // _items[index]
                    _items[index]
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final PredictionRow item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });
                },
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

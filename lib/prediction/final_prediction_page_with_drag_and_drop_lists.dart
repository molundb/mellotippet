import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/prediction/final_prediction_controller.dart';
import 'package:mellotippet/snackbar/snackbar_handler.dart';

class FinalPredictionPageWithDragAndDropLists extends ConsumerStatefulWidget {
  final SnackbarHandler snackbarHandler;

  const FinalPredictionPageWithDragAndDropLists(
      {super.key, required this.snackbarHandler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinalPredictionPageState();
}

class _FinalPredictionPageState
    extends ConsumerState<FinalPredictionPageWithDragAndDropLists> {
  final _formKey = GlobalKey<FormState>();

  final List<DragAndDropList> _contents = [];

  FinalPredictionController get controller =>
      ref.read(FinalPredictionController.provider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsernameAndCurrentCompetition();

      final finalists = DragAndDropList(
        header: const Center(child: Text('Final')),
        contentsWhenEmpty: Container(),
        canDrag: false,
        children: <DragAndDropItem>[],
      );

      final semifinalists = DragAndDropList(
        header: const Center(child: Text('Semifinal')),
        contentsWhenEmpty: Container(),
        canDrag: false,
        children: <DragAndDropItem>[],
      );

      final fifthPlace = DragAndDropList(
        header: const Center(child: Text('Plats 5')),
        contentsWhenEmpty: Container(),
        canDrag: false,
        children: <DragAndDropItem>[],
      );

      final others = DragAndDropList(
        header: const Center(child: Text('Övriga')),
        canDrag: false,
        contentsWhenEmpty: Container(),
        children: <DragAndDropItem>[
          // DragAndDropItem(child: const PredictionRow()),
          // DragAndDropItem(child: const PredictionRow()),
          // DragAndDropItem(child: const PredictionRow()),
          // DragAndDropItem(child: const PredictionRow()),
          // DragAndDropItem(child: const PredictionRow()),
          // DragAndDropItem(child: const PredictionRow()),
        ],
      );

      _contents.add(finalists);
      _contents.add(semifinalists);
      _contents.add(fifthPlace);
      _contents.add(others);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(FinalPredictionController.provider);

    // TODO: Figure out how to handle loading

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DragAndDropLists(
        children: _contents,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
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

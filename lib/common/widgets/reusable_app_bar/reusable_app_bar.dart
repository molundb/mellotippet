import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar/reusable_app_bar_controller.dart';

class ReusableAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final double toolbarHeight = 120;
  final String title;
  final String? subtitle;
  final PreferredSizeWidget? bottom;

  static const String signOut = 'Logga ut';
  static const String deleteAccount = 'Ta bort konto';

  const ReusableAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.bottom,
  });

  @override
  ConsumerState<ReusableAppBar> createState() => _ReusableAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _ReusableAppBarState extends ConsumerState<ReusableAppBar> {
  ReusableAppBarController get controller =>
      ref.read(reusableAppBarControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final sub = widget.subtitle;
    return AppBar(
      toolbarHeight: widget.toolbarHeight,
      centerTitle: true,
      title: SizedBox(
        height: widget.toolbarHeight,
        child: Column(
          children: [
            const SizedBox(height: 28),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontFamily: 'Lalezar',
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            if (sub != null) ...[
              Text(
                sub,
                style: const TextStyle(
                  height: 1,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ]
          ],
        ),
      ),
      bottom: widget.bottom,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onSelected: (value) {
            handleClick(value, context);
          },
          itemBuilder: (BuildContext context) {
            return {ReusableAppBar.signOut, ReusableAppBar.deleteAccount}
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  void handleClick(String value, BuildContext context) {
    switch (value) {
      case ReusableAppBar.signOut:
        controller.signOut();
        break;
      case ReusableAppBar.deleteAccount:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  const Text("Är du säker på att du vill ta bort ditt konto?"),
              content: const Text(
                  "Om du tar bort kontot försvinner kontot och all data associerat med kontot permanent."),
              actions: [
                TextButton(
                  onPressed: context.pop,
                  child: const Text('Avbryt'),
                ),
                TextButton(
                  child: const Text(
                    'Ta bort konto',
                  ),
                  onPressed: () {
                    controller.deleteUserInfoAndAccount();
                    context.pop();
                  },
                ),
              ],
            );
          },
        );
        break;
    }
  }
}

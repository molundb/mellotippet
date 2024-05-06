import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final PreferredSizeWidget? bottom;

  final double _toolbarHeight = 120;
  static const String signOut = 'Logga ut';
  static const String deleteAccount = 'Ta bort konto';

  ReusableAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.bottom,
  });

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  final DatabaseRepository databaseRepository = getIt.get<DatabaseRepository>();

  @override
  Widget build(BuildContext context) {
    final sub = subtitle;
    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      title: SizedBox(
        height: _toolbarHeight,
        child: Column(
          children: [
            const SizedBox(height: 28),
            Text(
              title,
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
      bottom: bottom,
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
            return {signOut, deleteAccount}.map((String choice) {
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
      case signOut:
        authRepository.signOut();
        break;
      case deleteAccount:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    "Är du säker på att du vill ta bort ditt konto?"),
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
                      databaseRepository.deleteUserInfoAndAccount(
                          authRepository.currentUser?.uid);
                      context.pop();
                    },
                  ),
                ],
              );
            });

        break;
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(_toolbarHeight + (bottom?.preferredSize.height ?? 0));
}

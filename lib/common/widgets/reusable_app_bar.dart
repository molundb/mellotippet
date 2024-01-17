import 'package:flutter/material.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  ReusableAppBar({
    super.key,
    required this.title,
    this.bottom,
  });

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 64,
          fontFamily: 'Lalezar',
        ),
      ),
      bottom: bottom,
      actions: [
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {'Logga ut'}.map((String choice) {
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

  void handleClick(String value) {
    switch (value) {
      case 'Logga ut':
        authRepository.signOut();
        break;
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(120 + (bottom?.preferredSize.height ?? 0));
}

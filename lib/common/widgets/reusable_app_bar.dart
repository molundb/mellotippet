import 'package:flutter/material.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final PreferredSizeWidget? bottom;

  final double _toolbarHeight = 120;

  ReusableAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.bottom,
  });

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

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
      Size.fromHeight(_toolbarHeight + (bottom?.preferredSize.height ?? 0));
}

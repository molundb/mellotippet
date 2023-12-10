import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/rules/final_rules.dart';
import 'package:mellotippet/rules/heat_rules.dart';
import 'package:mellotippet/styles/colors.dart';
import 'package:mellotippet/styles/text_styles.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          centerTitle: true,
          title: const Text(
            'Regler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontFamily: 'Lalezar',
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Deltävling'),
              Tab(text: 'Semifinal'),
              Tab(text: 'Final'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HeatRules(),
            FinalRules(),
            FinalRules(),
          ],
        ),
      ),
    );
  }
}

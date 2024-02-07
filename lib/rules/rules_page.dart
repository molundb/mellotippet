import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/widgets/reusable_app_bar.dart';
import 'package:mellotippet/rules/final_rules.dart';
import 'package:mellotippet/rules/heat_rules.dart';
import 'package:mellotippet/rules/semifinal_rules.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: ReusableAppBar(
          title: 'Regler',
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
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
            SemifinalRules(),
            FinalRules(),
          ],
        ),
      ),
    );
  }
}

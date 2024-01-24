import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mellotippet/common/models/competition_model.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/common/widgets/login_or_sign_up_page.dart';
import 'package:mellotippet/login/login_controller.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/service_location/get_it.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  LoginController get controller => ref.read(LoginController.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return LoginOrSignUpPage(
      ctaText: 'Registrera konto',
      ctaAction: _registerAccount,
      bottomText: 'Tillbaka till login',
      bottomAction: _pop,
      showUsernameField: true,
    );
  }

  Future<void> _registerAccount(BuildContext context,
      GlobalKey<FormState> formKey,) async {
    if (await controller.isUsernameAlreadyTaken()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username is already taken.'),
          ),
        );
      }
      return;
    }

    try {
      await controller.createUserWithEmailAndPassword();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              final currentCompetition =
                  getIt.get<FeatureFlagRepository>().getCurrentCompetition();
              final CompetitionType? competitionType = CompetitionType.values
                  .firstWhereOrNull(
                      (element) => describeEnum(element) == currentCompetition);
              return MelloBottomNavigationBar(
                currentCompetitionType: competitionType ?? CompetitionType.heat,
              );
            },
          ),
          ModalRoute.withName('/'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void _pop(BuildContext context) {
    Navigator.pop(context);
  }
}

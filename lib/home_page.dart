import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mellotippet/common/models/competition_model.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/login/login_page.dart';
import 'package:mellotippet/mello_bottom_navigation_bar.dart';
import 'package:mellotippet/service_location/get_it.dart';

class HomePage extends StatelessWidget {
  final authRepository = getIt.get<AuthenticationRepository>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _getLandingPage();
  }

  Widget _getLandingPage() {
    return StreamBuilder<User?>(
      stream: authRepository.firebaseAuth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // if (snapshot.data.providerData.length == 1) { // logged in using email and password
          //   return snapshot.data.isEmailVerified
          //       ? MainPage()
          //       : VerifyEmailPage(user: snapshot.data);
          // } else { // logged in using other providers
          final currentCompetition =
              getIt.get<FeatureFlagRepository>().getCurrentCompetition();
          final CompetitionType? competitionType = CompetitionType.values
              .firstWhereOrNull(
                  (element) => describeEnum(element) == currentCompetition);
          return MelloBottomNavigationBar(
              currentCompetitionType: competitionType ?? CompetitionType.heat);
          // }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
